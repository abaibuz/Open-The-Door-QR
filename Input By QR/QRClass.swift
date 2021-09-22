//
//  QRClass.swift
//  Input By QR
//
//  Created by Baibuz Oleksandr on 10.09.2021.
//

import AVFoundation
import UIKit

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    typealias readQRCode = (String?) -> ()
    var didReadQRCode: readQRCode?
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var textResult: String = "OK!"
    
    @IBAction func tappedExitButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

 //       dismiss(animated: true)
    }

    func found(code: String) {
        self.didReadQRCode!(code)
        analizeQRCode(QRCode: code)
    }
    //--------
    private func analizeQRCode(QRCode: String?) {
        if let qrCode = QRCode {
            
            if let subString = qrCode.substring(fromIndex: 0, toIndex: 5) {
       //         print(subString)
                if subString != "door_" {
                    textResult = "Incorrect QR-code"
                } else  if !AppDelegate.checkInternetConnection.hasInternet() {
                    textResult = "Check Internet Connection!"
                } else {
                    if let numberDoor = qrCode.substring(fromIndex: 5, toIndex: qrCode.count) {
                      //  print(numberDoor)
                        self.sendRequest(numberDoor: numberDoor)
                        return
                     } else {
                        textResult = "Incorrect QR-code"
                    }
                }
            } else {
                textResult = "Incorrect QR-code"
            }
            let alert = UIAlertController(title: "Error", message: textResult, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
            
        }

    }

    //------------
    func sendRequest(numberDoor: String)  {
        let url = AppDelegate.urlForOpenTheDoor + "?phone=" + AppDelegate.phone_Number + "&door=" + numberDoor
        guard let URL = URL(string: url.encodeUrl) else {
            textResult = "Incorrect URL!"
            return
        }
        let session = URLSession.shared
        var title = "Error"
        let task = session.dataTask(with: URL) { [self](data,response,error) in
            if let response = response {
                let response1 = response as! HTTPURLResponse
                switch  response1.statusCode {
                    case 200:
                        self.textResult = "OK!"
                        title = "Success"
                    case 404:
                        self.textResult = "URL don't found!"
                    default:
                        self.textResult = "Unknown!"
                }
            } else {
                    self.textResult = "No response!"
            }
            DispatchQueue.main.async{
                let alert = UIAlertController(title: title, message: self.textResult, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        task.resume()
    }
    

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

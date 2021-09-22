//
//  ViewController.swift
//  Input By QR
//
//  Created by Baibuz Oleksandr on 09.09.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedQRimage))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
    }

    @objc func tappedQRimage(_ sender: Any) {
        if AppDelegate.phone_Number == "" || AppDelegate.urlForOpenTheDoor == "" {
            let ac = UIAlertController(title: "Setting", message: "Set Phone Number & URL in App's setting", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        performSegue(withIdentifier: "openScannerSegue", sender: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openScannerSegue"  {
            let contoller = (segue.destination as! UINavigationController).topViewController as! ScannerViewController
            contoller.didReadQRCode  =  {   (QRCode) in
                  // self.analizeQRCode(QRCode: QRCode)
                }
            }
    }
    
 
}


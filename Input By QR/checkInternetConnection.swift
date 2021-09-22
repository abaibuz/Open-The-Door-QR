//
//  checkInternetConnection.swift
//  Open the Door(QR)
//
//  Created by Baibuz Oleksandr on 20.09.2021.
//

import Foundation
import Network

class CheckInternetConnection {
    
    let internetMonitor = NWPathMonitor()
    let internetQueue = DispatchQueue(label: "InternetMonitor")
    private var hasConnectionPath = false
    
    init() {
        startInternetTracking()
    }
    
    func startInternetTracking() {
        // only fires once
        guard internetMonitor.pathUpdateHandler == nil else {
            return
        }
        internetMonitor.pathUpdateHandler = { update in
            if update.status == .satisfied {
            //    print("Internet connection on.")
                self.hasConnectionPath = true
            } else {
             //   print("no internet connection.")
                self.hasConnectionPath = false
            }
        }
        internetMonitor.start(queue: internetQueue)
    }

    func hasInternet() -> Bool {
        return hasConnectionPath
    }

}

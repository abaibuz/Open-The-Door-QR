//
//  AppDelegate.swift
//  Input By QR
//
//  Created by Baibuz Oleksandr on 09.09.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    static var phone_Number: String = ""
    static var checkInternetConnection: CheckInternetConnection!
    static var urlForOpenTheDoor: String = ""
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let usrDefault = UserDefaults.standard
        if let phone_number = usrDefault.string(forKey: "phone_number") {
               AppDelegate.phone_Number = phone_number
        }
        if var url = usrDefault.string(forKey: "url") {
            if url.last != "/" {
                url += "/"
            }
               AppDelegate.urlForOpenTheDoor = url
            
        }

        AppDelegate.checkInternetConnection = CheckInternetConnection()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


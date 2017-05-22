//
//  AppDelegate.swift
//  Elite Condos
//
//  Created by Khoa on 11/1/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor(red:0.14, green:0.13, blue:0.24, alpha:1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    
        if #available(iOS 8.0, *) {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            let types: UIRemoteNotificationType = [.alert, .badge, .sound]
            application.registerForRemoteNotifications(matching: types)
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification(notification:)), name: NSNotification.Name.firInstanceIDTokenRefresh, object: nil)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
       
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //        FIRMessaging.messaging().disconnect()
          }

    func applicationWillEnterForeground(_ application: UIApplication) {
       
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        connectToFCM()
           }

    func applicationWillTerminate(_ application: UIApplication) {
      
    }
    
    func tokenRefreshNotification(notification: NSNotification) {
        if let token = FIRInstanceID.instanceID().token(){
            Api.User.updateTokenToDatabase(token: token, onSuccess: {
                UserDefaults.standard.setValue(token, forKey: "token")
                print("token in didRegister: \(token)")
                self.connectToFCM()
            })
            
        }
    }
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
        if let token = FIRInstanceID.instanceID().token(){
            Api.User.updateTokenToDatabase(token: token, onSuccess: {
                UserDefaults.standard.setValue(token, forKey: "token")
                print("token in didRegister: \(token)")
                self.connectToFCM()
            })
            
        }
    }
    func connectToFCM() {
        FIRMessaging.messaging().connect { (error) in
            
            if (error != nil) {
                print("Unable to connect to FCM \(error.debugDescription)")
            } else {
                print("Connected to FCM")
                
            }
        }
    }


}


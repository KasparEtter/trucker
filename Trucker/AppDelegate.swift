//
//  AppDelegate.swift
//  Trucker
//
//  Created by Kaspar Etter on 9.9.2016.
//  Copyright © 2016 Techfest Munich. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LoginViewControllerProtocol {

    var window: UIWindow?
    var navController: UINavigationController?
    var truckerAPI : TruckerAPI = TruckerAPI(baseURL: "https://dry-citadel-48051.herokuapp.com")
    var dashboardController : DashboardTableViewController = DashboardTableViewController()
    var loginController : LoginViewController = LoginViewController()

    var session: WCSession?
    
    func connectToFcm() {
        FIRMessaging.messaging().connectWithCompletion { (error) in
            if (error != nil) {
                print("Unable to connect with FCM: \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    func tokenRefreshNotification(notification: NSNotification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("new FCM registration token: \(refreshedToken)")
            self.registerUser(refreshedToken)
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }

    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        /**
         * prepare controller and initialize the 'DashboardViewController' on top of it
         * make several interface preparations
         */
        

        navController = UINavigationController()
        navController?.setNavigationBarHidden(true, animated: false);
        self.loginController.delegate = self
        self.navController!.pushViewController(loginController, animated: false)
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = navController
        self.window!.makeKeyAndVisible()
        
        // Override point for customization after application launch.
        registerForPushNotifications(application)
        FIRApp.configure()
        
//        let alertController = UIAlertController(title: "Check In Required", message:
//            "Do you want to check in for nico@digitalid.com?", preferredStyle: UIAlertControllerStyle.Alert)
//        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default,handler: nil))
//        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
//        self.navController!.presentViewController(alertController, animated: true, completion: nil)
        
        let token = FIRInstanceID.instanceID().token()
        if let unwrapped = token {
            print("FCM registration token: \(unwrapped)")
            self.registerUser(unwrapped)
        }
        
        // Add observer for InstanceID token refresh callback.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.tokenRefreshNotification), name: kFIRInstanceIDTokenRefreshNotification, object: nil)
        
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            print(session)
//            print(session.paired)
//            print(session.watchAppInstalled)
//            if session.paired && session.watchAppInstalled {
                self.session = session
                session.activateSession()
//            }
            print(session)
        } else {
            print("WCSession is not supported.")
        }
        
        return true
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Unknown)
        print("APNS device token:", tokenString)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("############################################")
        print("Failed to register for remote notifications:")
        print(error)
        print("############################################")
    }
    
    func updateApplicationContext(applicationContext: [String : AnyObject]) throws {
        if let session = self.session {
            try session.updateApplicationContext(applicationContext)
            print("Updated the application context.")
        } else {
            print("There is no default session.")
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        
        // Print message ID.
//        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        print(userInfo)
        
        let number = arc4random_uniform(100)
        print("number: ", number)
        do {
            try updateApplicationContext(["number": Int(number)])
        } catch let error {
            print("An error occurred while updating the application context.")
            print(error)
        }
        
        completionHandler(UIBackgroundFetchResult.NewData)
    }
    
    func registerUser(token: String) {
        self.loginController.token = token
    }
    
    func loginSuccessful(user: String) {
        self.dashboardController.firstName = "Johnny"
        self.dashboardController.licensePlate = "TE CH 13 31"
        self.navController!.pushViewController(self.dashboardController, animated: true)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        connectToFcm()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


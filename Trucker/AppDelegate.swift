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
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LoginViewControllerProtocol, TruckerDataProtocol {

    var window: UIWindow?
    var navController: UINavigationController?
    var truckerAPI : TruckerAPI = TruckerAPI(baseURL: "https://dry-citadel-48051.herokuapp.com")
    var truckerData : TruckerData = TruckerData();
    var dashboardController : DashboardTableViewController = DashboardTableViewController()
    var loginController : LoginViewController = LoginViewController()
    var deviceApproved : Bool = false;
    
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
            if(deviceApproved) {
                truckerAPI.register("johnny@digitalid.net", token: refreshedToken) { (res) in
                    print(res)
                }
            } else {
                self.loginController.token = refreshedToken
            }
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
        
        self.truckerData.delegate = self
        self.truckerData.startDataStream()
        self.loginController.delegate = self
        navController = UINavigationController()
        navController?.setNavigationBarHidden(true, animated: false);

        
        // load UserDefaults
        let defaults = NSUserDefaults.standardUserDefaults()
        deviceApproved = defaults.boolForKey("deviceApproved")
        print("device is approved: " + String(deviceApproved));
        
        if (deviceApproved) {
            self.navController!.pushViewController(dashboardController, animated: false)
        } else {
            self.navController!.pushViewController(loginController, animated: false)
        }
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = navController
        self.window!.makeKeyAndVisible()
        
        // Override point for customization after application launch.
        registerForPushNotifications(application)
        FIRApp.configure()
        
        let token = FIRInstanceID.instanceID().token()
        if let unwrapped = token {
            print("FCM registration token: \(unwrapped)")
            if(deviceApproved) {
                truckerAPI.register("johnny@digitalid.net", token: unwrapped) { (res) in
                    print(res)
                }
            } else {
                self.loginController.token = unwrapped
            }
        }
        
        // Add observer for InstanceID token refresh callback.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.tokenRefreshNotification), name: kFIRInstanceIDTokenRefreshNotification, object: nil)
        
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
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.

        if userInfo["PushRequest"] != nil {
            let json = JSON(data: (userInfo["PushRequest"] as! NSString).dataUsingEncoding(NSUTF8StringEncoding)!)
            if let type = json["action"]["type"].string {
                switch type {
                case "AuthenticationRequestAction":
                    // handle login
                    if let resource = json["responseResource"].string {
                        truckerAPI.login(resource, completionHandler: { (res) in
                            self.loginController.approval = true
                            self.deviceApproved = true
                        })
                    }
                    break
                case "SpeedRequestAction":
                    // handle speed
                    if let speed = json["action"]["speed"].int {
                        self.truckerData.currentSpeed = speed
                    }
                    break
                default:
                    // break out
                    break
                }
            }
        }
        
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.NewData)
    }
    
    func checkInSuccessful(user: String) {
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
        
        // set defaults
        print("saving defaults...")
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(true, forKey: "deviceApproved")
        defaults.synchronize()
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
    
    func newTruckerDataReceived() {
        // push new data out
        self.dashboardController.currentSpeed = self.truckerData.currentSpeed
        //self.dashboardController.averageSpeed = self.truckerData.averageSpeed
        self.dashboardController.firstName = self.truckerData.customerName
        self.dashboardController.remainingShift = self.truckerData.remainingShift
        self.dashboardController.licensePlate = self.truckerData.licensePlate
    }
    
    func handleTruckerEventReceived(event: String) {
        switch event {
        case "SPEEDING":
            let alertController = UIAlertController(title: "Warning!", message:
                "You are driving too fast. Please slow down a bit!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Okay, I'll slow down.", style: UIAlertActionStyle.Default,handler: nil))
            self.window!.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
            break
        case "STILL_DRIVING":
            let alertController = UIAlertController(title: "Warning!", message:
                "Please take a rest. You're not allowed to drive anymore.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Okay, I'll sleep.", style: UIAlertActionStyle.Default,handler: nil))
            self.window!.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
            break
        default:
            break
        }
    }

}

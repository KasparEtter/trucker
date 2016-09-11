//
//  HomeInterfaceController.swift
//  Trucker
//
//  Created by Nico Hänggi on 11/09/16.
//  Copyright © 2016 Nico Hänggi. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class HomeInterfaceController: WKInterfaceController {
    
    var session: WCSession!
    
    @IBOutlet var locationLabel: WKInterfaceLabel!
    @IBOutlet var speedLabel: WKInterfaceLabel!
    @IBOutlet var secondLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }
    
    override func didAppear() {
        super.didAppear()
        
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session!.sendMessage(["type": "SEND_UPDATES"], replyHandler: { (response) -> Void in
                print("AppleWatch Part")
                print(response)
                }, errorHandler: { (error) -> Void in
                    print(error)
            })
        }
        
    }
    
    override func willActivate() {
        super.willActivate()
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        //handle received message
        print("message received")
        
        if let type = message["type"] as? String {
            switch type {
            case "SPEED":
                replyHandler(["type":"SPEED_RECEIVED"])
                if let speed = message["value"] as? Int {
                    self.speedLabel.setText(String(speed))
                    if (speed <= 50) {
                        self.locationLabel.setText("Munich, Germany")
                    }
                }
                break
            case "SPEEDING":
                replyHandler(["type":"SPEEDING_RECEIVED"])
                self.locationLabel.setText("Not so Fast!")
                WKInterfaceDevice.currentDevice().playHaptic(.Failure)
                WKInterfaceDevice.currentDevice().playHaptic(.Failure)
                WKInterfaceDevice.currentDevice().playHaptic(.Failure)
                WKInterfaceDevice.currentDevice().playHaptic(.Failure)
                WKInterfaceDevice.currentDevice().playHaptic(.Failure)
                break
            default:
                break
            }
        }
        
        
    }
    
    func showPopup(){
        
        let h0 = { print("ok")}
        
        let action1 = WKAlertAction(title: "Approve", style: .Default, handler:h0)
        let action2 = WKAlertAction(title: "Decline", style: .Destructive) {}
        let action3 = WKAlertAction(title: "Cancel", style: .Cancel) {}
        
        presentAlertControllerWithTitle("Voila", message: "", preferredStyle: .ActionSheet, actions: [action1, action2,action3])
        
        
    }
    
}

extension HomeInterfaceController: WCSessionDelegate {
    
}

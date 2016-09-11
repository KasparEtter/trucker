//
//  InterfaceController.swift
//  Trucker WatchKit Extension
//
//  Created by Kaspar Etter on 9.9.2016.
//  Copyright © 2016 Techfest Munich. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {

    @IBOutlet var label: WKInterfaceLabel!
    
    @IBAction func vibrate() {
        WKInterfaceDevice.currentDevice().playHaptic(.Failure)
        
        // Send Message
        let messageToSend = ["Value":"Hello iPhone"]
        session.sendMessage(messageToSend, replyHandler: { replyMessage in
            //handle and present the message on screen
            let value = replyMessage["Value"] as? String
            print("yeah")
            }, errorHandler: {error in
                // catch any errors here
                print(error)
        })
    }
    
    var session: WCSession!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        label.setText("hallo")
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

}

extension InterfaceController: WCSessionDelegate {
    
}

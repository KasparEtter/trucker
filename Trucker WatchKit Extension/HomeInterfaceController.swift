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
                self.secondLabel.setText(String(response))
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
                }
                break
            default:
                break
            }
        }
        
        
    }
    
    
}

extension HomeInterfaceController: WCSessionDelegate {
    
}

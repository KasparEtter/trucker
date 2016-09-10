//
//  SessionDelegate.swift
//  Trucker
//
//  Created by Kaspar Etter on 10.9.2016.
//  Copyright © 2016 Techfest Munich. All rights reserved.
//

import Foundation

import WatchConnectivity

class SessionDelegate: NSObject, WCSessionDelegate {
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        InterfaceController.setLabel("session received")
        InterfaceController.setLabel(applicationContext["number"].debugDescription)
    }
    
}
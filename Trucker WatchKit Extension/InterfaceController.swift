//
//  InterfaceController.swift
//  Trucker WatchKit Extension
//
//  Created by Kaspar Etter on 9.9.2016.
//  Copyright © 2016 Techfest Munich. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    static var staticLabel: WKInterfaceLabel!
    
    static func setLabel(string: String) {
        staticLabel.setText(string)
    }

    @IBOutlet var label: WKInterfaceLabel!
    
    @IBAction func vibrate() {
        WKInterfaceDevice.currentDevice().playHaptic(.Failure)
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        label.setText("hallo")
        InterfaceController.staticLabel = label
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

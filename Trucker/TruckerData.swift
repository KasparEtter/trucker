//
//  TruckerData.swift
//  Trucker
//
//  Created by Nico Hänggi on 11/09/16.
//  Copyright © 2016 Nico Hänggi. All rights reserved.
//

import UIKit

protocol TruckerDataProtocol : NSObjectProtocol {
    func newTruckerDataReceived()
    func handleTruckerEventReceived(event: String)
}

class TruckerData: NSObject {
    
    // ViewController Delegate
    weak var delegate: TruckerDataProtocol?
    
    // Timer
    private var timer : NSTimer?
    private var shiftTimer : NSTimer?
    
    // Properties
    var customerName = "Johnny"
    var licensePlate = "TE CH 13 31"
    
    private var _speedArray : [Int] = []
    private var _currentSpeed : Int = 0
    private var _firstTimePushed : Double?
    private var _remainingShift : Float = 8
    private var _isInBreak : Bool = false
    
    var averageSpeed : Int {
        set {}
        get {
            if (_speedArray.count == 0) {
                return 0
            }
            var fullSpeed = 0
            for speed in _speedArray {
                fullSpeed += speed
            }
            return Int(fullSpeed/_speedArray.count)
        }
    }
    
    
    var currentSpeed : Int {
        set {
            if (_firstTimePushed == nil) {
                _firstTimePushed = NSDate().timeIntervalSince1970*1000
                // start timer
                shiftTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(countBack), userInfo: nil, repeats: true)
            }
            _currentSpeed = newValue
            if(_currentSpeed > 50) {
                self.delegate?.handleTruckerEventReceived("SPEEDING")
            }
            pushUpdate()
        }
        get {
            return _currentSpeed
        }
    }
    
    var remainingShift : Float {
        set {
            _remainingShift = newValue
            pushUpdate()
        }
        get {
            return _remainingShift
        }
    }
    
    
    func startDataStream() {
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(pushUpdate), userInfo: nil, repeats: true)
    }
    
    func stopDataStream() {
        if let timed = timer {
            timed.invalidate()
        }
    }
    
    func pushUpdate() {
        delegate?.newTruckerDataReceived()
    }
    
    func countBack() {
        // always add current Speed
        _speedArray.append(_currentSpeed)
        // end add current Speed
        if (_isInBreak) {
            if (_currentSpeed > 0) {
                self.delegate?.handleTruckerEventReceived("STILL_DRIVING")
                return
            }
            _remainingShift += 0.2
            if (_remainingShift >= 0.0) {
                _remainingShift = 8
                _isInBreak = false
            }
            return
        }
        if (_firstTimePushed != nil && _currentSpeed > 0) {
            if (_remainingShift >= 0.2) {
                _remainingShift -= 0.2
            } else {
                if(!_isInBreak) {
                    _isInBreak = true
                    _remainingShift = -8
                    
                }
            }
        }
        pushUpdate()
    }
  
}

//
//  DashboardTableViewController.swift
//  Trucker
//
//  Created by Nico Hänggi on 10/09/16.
//  Copyright © 2016 Nico Hänggi. All rights reserved.
//

import UIKit

class DashboardTableViewController: UITableViewController, StepperTableViewCellProtocol{
    
    // Dashboard Properties

    private var welcomeTitle : String = "Your Truck Data"
    private var dashboardBackgroundColor : UIColor = UIColor(red: 28/255, green: 33/255, blue: 40/255, alpha: 1)
    private var currentSpeedLabel = "Current Speed"
    private var averageSpeedLabel = "Average Speed"
    private var remainingShiftLabel = "Remaining Shift"
    private var currentTaskLabel = "You need to"
    private var currentTemperatureLabel = "Current Temperature"
    private var timeType = "hours"
    private var speedType = "km/h"
    private var temperatureType = "C°"
    
    // Dashboard Data
    private var _licensePlate : String = ""
    private var _firstName : String = "Customer"
    private var _currentSpeed : Int = 0;
    private var _averageSpeed : Int = 0;
    private var _remainingShift : Float = 0;
    private var _currentTemperature : Float = 0;
    var licensePlate : String {
        set {
            print("new license plate set: " + newValue)
            _licensePlate = newValue
            self.reloadData();
        }
        get {
            return _licensePlate
        }
    }
    var firstName : String {
        set {
            print("new first name set: " + newValue)
            _firstName = newValue
            self.reloadData();
        }
        get {
            return _firstName
        }
    }
    var currentSpeed : Int {
        set {
            print("new current speed value set: " + String(newValue))
            _currentSpeed = newValue
            self.reloadData();
        }
        get {
            return _currentSpeed
        }
    }
    var averageSpeed : Int {
        set {
            print("new first name set: " + String(newValue))
            _averageSpeed = newValue
            self.reloadData();
        }
        get {
            return _averageSpeed
        }
    }
    var remainingShift : Float {
        set {
            print("new remaining shift set: " + String(newValue))
            _remainingShift = newValue
            self.reloadData();
        }
        get {
            return _remainingShift
        }
    }
    var currentTemperature : Float {
        set {
            print("new temperature set: " + String(newValue))
            _currentTemperature = newValue
            self.reloadData();
        }
        get {
            return _currentTemperature
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // preserve selection when loading again
        self.clearsSelectionOnViewWillAppear = false
        
        // hide separating lines if no cell existing
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = UIColor.clearColor()
        
        // register nib-cells
        self.tableView.registerNib(UINib(nibName: WelcomeTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: WelcomeTableViewCell.identifier)
        self.tableView.registerNib(UINib(nibName: NumberChartTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NumberChartTableViewCell.identifier)
        self.tableView.registerNib(UINib(nibName: NumberGraphicTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NumberGraphicTableViewCell.identifier)
        self.tableView.registerNib(UINib(nibName: StepperTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: StepperTableViewCell.identifier)

        // prepare separator
        self.tableView.separatorColor = UIColor.clearColor()
        
        // change background color of view
        self.view.backgroundColor = self.dashboardBackgroundColor
        self.navigationController?.navigationBar.clipsToBounds = true
        
        // Fake Update
        let triggerTime = (Int64(NSEC_PER_SEC) * 3)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            self.licensePlate = "YOO"
            self.firstName = "Nico Hänggi"
            self.currentSpeed = 150
            self.averageSpeed = 80
            self.remainingShift = 1.7
            self.currentTemperature = 22.0
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    // preparing cells for appearing in the TableView
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if (indexPath.row == 0) {
            cell = tableView.dequeueReusableCellWithIdentifier(WelcomeTableViewCell.identifier, forIndexPath: indexPath)
            cell.backgroundColor = self.dashboardBackgroundColor
            (cell as! WelcomeTableViewCell).welcomeText.text = ("Hi " + self.firstName + ",").uppercaseString
            (cell as! WelcomeTableViewCell).welcomeTitle.text = (self.welcomeTitle).uppercaseString
            (cell as! WelcomeTableViewCell).welcomeSubtitle.text = ("License Plate: " + self.licensePlate).uppercaseString
        } else if (indexPath.row == 1) {
            cell = tableView.dequeueReusableCellWithIdentifier(NumberChartTableViewCell.identifier, forIndexPath: indexPath)
            cell.backgroundColor = self.dashboardBackgroundColor
            (cell as! NumberChartTableViewCell).firstEntryTitle.text = self.currentSpeedLabel.uppercaseString
            (cell as! NumberChartTableViewCell).secondEntryTitle.text = self.averageSpeedLabel.uppercaseString
            (cell as! NumberChartTableViewCell).firstEntryValue.text = String(self.currentSpeed)
            (cell as! NumberChartTableViewCell).secondEntryValue.text = String(self.averageSpeed)
            (cell as! NumberChartTableViewCell).firstEntryText.text = self.speedType
            (cell as! NumberChartTableViewCell).secondEntryText.text = self.speedType
            
        } else if (indexPath.row == 2) {
            cell = tableView.dequeueReusableCellWithIdentifier(NumberGraphicTableViewCell.identifier, forIndexPath: indexPath)
            cell.backgroundColor = self.dashboardBackgroundColor
            (cell as! NumberGraphicTableViewCell).firstEntryTitle.text = self.remainingShiftLabel.uppercaseString
            (cell as! NumberGraphicTableViewCell).secondEntryTitle.text = self.currentTaskLabel.uppercaseString
            (cell as! NumberGraphicTableViewCell).firstEntryText.text = self.timeType
            (cell as! NumberGraphicTableViewCell).firstEntryValue.text = String(format: "%.1f", self.remainingShift)

            
        } else if (indexPath.row == 3) {
            cell = tableView.dequeueReusableCellWithIdentifier(StepperTableViewCell.identifier, forIndexPath: indexPath)
            cell.backgroundColor = self.dashboardBackgroundColor
            (cell as! StepperTableViewCell).delegate = self
            (cell as! StepperTableViewCell).firstEntryTitle.text = self.currentTemperatureLabel.uppercaseString
            (cell as! StepperTableViewCell).firstEntryValue.text = String(format: "%.1f", self.currentTemperature)
            (cell as! StepperTableViewCell).firstEntryText.text = self.temperatureType
        }
    
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (indexPath.row == 0) {
            return WelcomeTableViewCell.height
        } else if (indexPath.row == 1) {
            return NumberChartTableViewCell.height
        } else if (indexPath.row == 2) {
            return NumberGraphicTableViewCell.height
        } else if (indexPath.row == 3) {
            return StepperTableViewCell.height
        }
        return 20
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    private func reloadData() {
        self.tableView.reloadData();
    }
    
    func stepperUpdated(event: String) -> String {
        switch event {
        case "INCREASED":
            self.currentTemperature += 1
            return String(format: "%.1f", self.currentTemperature)
        case "LOWERED":
            self.currentTemperature -= 1
            return String(format: "%.1f", self.currentTemperature)
        default:
            return ""
        }
    }
    
    
}

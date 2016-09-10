//
//  DashboardTableViewController.swift
//  Trucker
//
//  Created by Nico Hänggi on 10/09/16.
//  Copyright © 2016 Nico Hänggi. All rights reserved.
//

import UIKit

class DashboardTableViewController: UITableViewController {
    
    // Dashboard Properties
    var licensePlate : String = "RA KL 81 36"
    var firstName : String = "Nico"
    var welcomeTitle : String = "Your Truck Data"
    var dashboardBackgroundColor : UIColor = UIColor(red: 28/255, green: 33/255, blue: 40/255, alpha: 1)
    var currentSpeedLabel = "Current Speed"
    var averageSpeedLabel = "Average Speed"
    var speedType = "km/h"
    
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
        
        // prepare separator
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = UIColor.clearColor()
        
        // prepare appearance
        self.title = "Title"
        
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
            (cell as! NumberChartTableViewCell).firstEntryText.text = self.speedType
            (cell as! NumberChartTableViewCell).secondEntryText.text = self.speedType
            
        } else if (indexPath.row == 2) {
//            cell = tableView.dequeueReusableCellWithIdentifier(TextViewCell.identifier, forIndexPath: indexPath)
//            (cell as! TextViewCell).titleLabel.text = self.issueDescription
            
        } else if (indexPath.row == 3) {
//            cell = tableView.dequeueReusableCellWithIdentifier(HorizontalImageLabelCell.identifier, forIndexPath: indexPath)
//            cell.backgroundColor = self.profileBackgroundColor
//            (cell as! HorizontalImageLabelCell).titleLabel.text = self.profileTitle
        }
    
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (indexPath.row == 0) {
            return WelcomeTableViewCell.height
        } else if (indexPath.row == 1) {
            return NumberChartTableViewCell.height
        } else if (indexPath.row == 2) {
//            return TextViewCell.height
        } else if (indexPath.row == 3) {
//            return HorizontalImageLabelCell.height
        }
        return 20
    }
    
    
}

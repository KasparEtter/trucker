//
//  StepperTableViewCell.swift
//  Trucker
//
//  Created by Nico Hänggi on 10/09/16.
//  Copyright © 2016 Nico Hänggi. All rights reserved.
//

import UIKit

protocol StepperTableViewCellProtocol : NSObjectProtocol {
    func stepperUpdated(event: String) -> String
}

class StepperTableViewCell: UITableViewCell {
    
    // ViewController Delegate
    weak var delegate: StepperTableViewCellProtocol?
    
    // First entry
    @IBOutlet weak var firstEntryText: UILabel!
    @IBOutlet weak var firstEntryValue: UILabel!
    @IBOutlet weak var firstEntryTitle: UILabel!
    
    // Static properties
    static let height : CGFloat = 110
    static let identifier = "StepperTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.blackColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func plusButtonClicked(sender: AnyObject) {
        self.firstEntryValue.text = self.delegate?.stepperUpdated("INCREASED")
        
    }
    @IBAction func minusButtonClicked(sender: AnyObject) {
        self.firstEntryValue.text = self.delegate?.stepperUpdated("LOWERED")
    }
    
}

//
//  NumberChartTableViewCell.swift
//  Trucker
//
//  Created by Nico Hänggi on 10/09/16.
//  Copyright © 2016 Nico Hänggi. All rights reserved.
//

import UIKit

class NumberGraphicTableViewCell: UITableViewCell {
    
    // First entry
    @IBOutlet weak var firstEntryText: UILabel!
    @IBOutlet weak var firstEntryValue: UILabel!
    @IBOutlet weak var firstEntryTitle: UILabel!
    @IBOutlet weak var secondEntryTitle: UILabel!
    @IBOutlet weak var secondEntryImageView: UIImageView!
    
    // Static properties
    static let height : CGFloat = 110
    static let identifier = "NumberGraphicTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.blackColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setColor(color: UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)) {
        firstEntryText.textColor = color
        firstEntryValue.textColor = color
    }
    
}

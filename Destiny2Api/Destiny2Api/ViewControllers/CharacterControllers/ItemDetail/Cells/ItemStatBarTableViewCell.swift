//
//  ItemStatBarTableViewCell.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 17/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import UIKit

class ItemStatBarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var progressContainer: UIView!
    @IBOutlet weak var vProgress: UIView!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var progressConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupWith(stat: StatUI) {
        
        lblName.text = stat.name
        lblValue.text = "\(stat.value)"
        
        UIView.animate(withDuration: 1.5) {
            self.progressConstraint.constant = self.progressContainer.frame.width * CGFloat(stat.value / stat.maxValue)
        }
    }
}

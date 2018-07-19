//
//  ItemInfoTableViewCell.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 17/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import UIKit

class ItemInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblClass: UILabel!
    @IBOutlet weak var lblLight: UILabel!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var lblRequiredLvl: UILabel!
    @IBOutlet weak var vItemColor: UIView!
    @IBOutlet weak var imgItem: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupWith(item: ItemUI) {
        lblName.text = item.manifest.display.name
        lblClass.text = item.manifest.typeName
        lblAbout.text = item.manifest.display.about
        if let requiredLvl = item.instance?.equipRequiredLevel {
            lblRequiredLvl.text = "\(requiredLvl)"
            lblRequiredLvl.isHidden = false
        } else {
            lblRequiredLvl.isHidden = true
        }
        vItemColor.backgroundColor = item.manifest.color
        imgItem.kf.setImage(with: item.manifest.urlScreenshot)
    }
}

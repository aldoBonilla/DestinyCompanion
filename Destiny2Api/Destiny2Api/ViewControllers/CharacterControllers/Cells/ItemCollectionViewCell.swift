//
//  ItemCollectionViewCell.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 13/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import UIKit
import Kingfisher

class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var lblLight: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var overImage: UIView!
    
    func setupWith(item: Item) {
        
        imgItem.kf.setImage(with: item.manifest.urlItemImage)
        
        if item.inventory.quantity > 1 {
            self.lblQuantity.isHidden = false
            self.lblQuantity.text = "\(item.inventory.quantity)"
        } else {
            self.lblQuantity.isHidden = true
        }
        
        if let instance = item.instance {
            
            self.overImage.isHidden = false
            self.lblLight.isHidden = false
            self.lblLight.text = "\(instance.primaryStatValue)"
            
        } else {
            self.overImage.isHidden = true
            self.lblLight.isHidden = true
        }
    }
}

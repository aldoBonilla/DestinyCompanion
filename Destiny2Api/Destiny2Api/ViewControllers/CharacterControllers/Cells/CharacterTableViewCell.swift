//
//  CharacterTableViewCell.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 04/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import UIKit
import Kingfisher

class CharacterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblClass: UILabel!
    @IBOutlet weak var lblLevel: UILabel!
    @IBOutlet weak var lblLight: UILabel!
    @IBOutlet weak var progressContainer: UIView!
    @IBOutlet weak var progress: UIView!
    @IBOutlet weak var progressConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgBanner: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        progressConstraint.constant = 0.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setup(character: Character) {
        
        lblClass.text = character.classType.description
        lblLevel.text = "\(character.level)"
        lblLight.text = "\(character.light)"
        if let urlBanner = character.urlBannerBackground {
            imgBanner.kf.setImage(with: urlBanner)
        }
        
        UIView.animate(withDuration: 1.5) {
            self.progressConstraint.constant = self.progressContainer.frame.width * CGFloat(character.percentToNextLevel / 100)
        }
    }

}

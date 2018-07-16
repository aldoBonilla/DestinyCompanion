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
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var bgImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        progressConstraint.constant = 0.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        let colorContainer = self.progressContainer.backgroundColor
        let colorProgress = self.progress.backgroundColor
        
        super.setSelected(selected, animated: animated)
        
        if selected == true {
            self.progressContainer.backgroundColor = colorContainer
            self.progress.backgroundColor = colorProgress
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let colorContainer = self.progressContainer.backgroundColor
        let colorProgress = self.progress.backgroundColor
        
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted == true {
            self.progressContainer.backgroundColor = colorContainer
            self.progress.backgroundColor = colorProgress
        }
    }
    
    public func setup(character: Character) {
        
        lblClass.text = character.classType.name
        lblLevel.text = "\(character.level)"
        lblLight.text = "\(character.light)"
        if let urlBanner = character.urlBannerBackground {
            imgBanner.kf.setImage(with: urlBanner)
            bgImage.kf.setImage(with: urlBanner)
        }
        
        self.backgroundColor = character.emblemColor
        
        UIView.animate(withDuration: 1.5) {
            self.progressConstraint.constant = self.progressContainer.frame.width * CGFloat(character.percentToNextLevel / 100)
        }
    }

}

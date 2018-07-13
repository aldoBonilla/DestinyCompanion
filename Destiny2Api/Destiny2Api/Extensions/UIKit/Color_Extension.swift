//
//  Color_Extension.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 13/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init?(dictionary: EntityDictionary) {
        guard let red = dictionary["red"] as? Int,
            let green = dictionary["green"] as? Int,
            let blue = dictionary["blue"] as? Int,
            let alpha = dictionary["alpha"] as? Int else {
                return nil
        }
        self.init(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: CGFloat(alpha/255))
    }
}

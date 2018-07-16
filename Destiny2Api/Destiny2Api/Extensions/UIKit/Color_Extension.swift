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
        
        let fRed = CGFloat(red)
        let fGreen = CGFloat(green)
        let fBlue = CGFloat(blue)
        let fAlpha = CGFloat(alpha)
        
        self.init(red: fRed/255.0, green: fGreen/255.0, blue:fBlue/255.0, alpha: fAlpha/255.0)
    }
    
    func rgb() -> (red:Int, green:Int, blue:Int, alpha:Int)? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            
            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
}

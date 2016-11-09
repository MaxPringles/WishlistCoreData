//
//  MaterialView.swift
//  Wishlist
//
//  Created by Vanessa on 13/10/16.
//  Copyright © 2016 Telstock. All rights reserved.
//

import UIKit

class MaterialView: UIView {

    private var materialKey = false
    
    @IBInspectable var materialDesign: Bool {
        
        get {
            return materialKey
        }
        
        set {
            materialKey = newValue
            
            if materialKey {
                self.layer.masksToBounds = false
                // Redondear
                self.layer.cornerRadius = 3.0
                // Sombra
                self.layer.shadowOpacity = 0.8
                // Redondeo sombra
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
                self.layer.shadowColor = UIColor(red: 157.0 / 255.0, green: 157.0 / 255.0, blue: 157.0 / 255.0, alpha: 1.0).cgColor
            } else {
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
            }
        }
    }

}

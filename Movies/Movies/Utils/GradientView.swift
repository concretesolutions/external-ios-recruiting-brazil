//
//  GradientView.swift
//  Movies
//
//  Created by Alexandre Thadeu on 07/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation
import UIKit

class GradientView: UIView {

    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.colors = [
            UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.00).cgColor,
            UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.70).cgColor
        ]
        backgroundColor = UIColor.clear
    }
}

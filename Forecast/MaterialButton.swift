//
//  MaterialButton.swift
//  Forecast
//
//  Created by Neel Nishant on 23/01/17.
//  Copyright © 2017 Neel Nishant. All rights reserved.
//

import UIKit

class MaterialButton: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).cgColor
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }

}

//
//  MaterialTextField.swift
//  Forecast
//
//  Created by Neel Nishant on 23/01/17.
//  Copyright © 2017 Neel Nishant. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {

    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.1).cgColor
        layer.borderWidth = 1.0
    }
    
    //for placeholder
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    //for editable text
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
}

//
//  CloseButton.swift
//  apphere
//
//  Created by Tony Mann on 2/17/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit

@IBDesignable
class CloseButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -hitMargin, dy: -hitMargin).contains(point)
    }
    
    @IBInspectable var hitMargin: CGFloat = 15.0
}

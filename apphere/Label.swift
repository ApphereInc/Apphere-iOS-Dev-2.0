//
//  Label.swift
//  apphere
//
//  Created by Tony Mann on 2/16/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit

@IBDesignable
class Label: UILabel {
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        let padding = (1.0 - lineHeightMultiple) * font.pointSize
        size.height += padding
        return size
    }
    
    override var text: String? {
        didSet {
            updateAttributedText()
        }
    }
    
    private func updateAttributedText() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        attributedText = NSAttributedString(string: text ?? "", attributes: [
            .font: font,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: textColor
        ])
        invalidateIntrinsicContentSize()
    }
    
    @IBInspectable var lineHeightMultiple: CGFloat = 1.0 {
        didSet {
            updateAttributedText()
        }
    }
}

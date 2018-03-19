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
    
    override var attributedText: NSAttributedString? {
        didSet {
            updateAttributedText()
        }
    }
    
    private func updateAttributedText() {
        if isUpdatingAttributedText {
            return
        }
        
        isUpdatingAttributedText = true
        let currentAttributedText = attributedText ?? NSAttributedString(string: text ?? "")
        let currentParagraphStyle = attributedText?.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle
        let paragraphStyle = (currentParagraphStyle ?? NSParagraphStyle()).mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let newAttributedText = currentAttributedText.mutableCopy() as! NSMutableAttributedString
        newAttributedText.addAttributes([.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: currentAttributedText.length))
        
        attributedText = newAttributedText
        isUpdatingAttributedText = false
        
        invalidateIntrinsicContentSize()
    }
    
    @IBInspectable var lineHeightMultiple: CGFloat = 1.0 {
        didSet {
            updateAttributedText()
        }
    }
    
    var isUpdatingAttributedText = false
}

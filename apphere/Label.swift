//
//  Label.swift
//  apphere
//
//  Created by Tony Mann on 2/16/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit

//@IBDesignable
class Label: UILabel {
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        let padding = (1.0 - lineHeightMultiple) * font.pointSize
        size.height += padding
        return size
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let currentParagraphStyle = attributedText?.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle
        lineHeightMultiple = currentParagraphStyle?.lineHeightMultiple ?? 0.0
    }
    
    override var text: String? {
        didSet {
            if isUpdatingAttributedText {
                return
            }
            
            isUpdatingAttributedText = true
            let currentParagraphStyle = attributedText?.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle
            let currentParagraphStyleMutable = currentParagraphStyle?.mutableCopy() as? NSMutableParagraphStyle
            let paragraphStyle = currentParagraphStyleMutable ?? NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = lineHeightMultiple
            let newAttributedText = attributedText?.mutableCopy() as! NSMutableAttributedString
            newAttributedText.addAttributes([.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributedText?.length ?? 0))
            attributedText = newAttributedText
            isUpdatingAttributedText = false
            
            invalidateIntrinsicContentSize()
        }
    }

    var lineHeightMultiple: CGFloat = 0.0
    var isUpdatingAttributedText = false
}

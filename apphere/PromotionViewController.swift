//
//  PromotionViewController.swift
//  apphere
//
//  Created by Tony Mann on 2/26/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class PromotionViewController: UIViewController {
    var business: Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let promotion = business.promotion
        
        view.backgroundColor = promotion.backgroundColor.map { UIColor($0) } ?? .white
        
        setLabelStyledText(upperHeadlineLabel, promotion.upperHeadline, isUppercase: true)
        setLabelStyledText(lowerHeadlineLabel, promotion.lowerHeadline, isUppercase: true)
        setLabelStyledText(featuredNotesLabel, promotion.featuredNotes, isUppercase: false)
    }
    
    private func setLabelStyledText(_ label: UILabel, _ styledText: StyledText?, isUppercase: Bool) {
        if let styledText = styledText {
            label.text = isUppercase ? styledText.text.uppercased() : styledText.text
            label.textColor = UIColor(styledText.color)
            label.font = styledText.isBold ? .boldSystemFont(ofSize: label.font.pointSize) : .systemFont(ofSize: label.font.pointSize)
            label.isHidden = false
        } else {
            label.isHidden = true
        }
    }

    @IBOutlet weak var upperHeadlineLabel: UILabel!
    @IBOutlet weak var lowerHeadlineLabel: UILabel!
    @IBOutlet weak var featuredNotesLabel: UILabel!
}

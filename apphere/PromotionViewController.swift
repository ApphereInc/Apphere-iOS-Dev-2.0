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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let promotion = business.promotion
        
        view.backgroundColor = promotion.backgroundColor.map { UIColor($0) } ?? .white
        configure(label: headlineLabel, styledText: promotion.headline, isUppercase: true)
        configure(label: footerLabel, styledText: promotion.footer, isUppercase: false)
        
        if let logo = promotion.logo {
            configure(imageView: logoImageView, imageName: logo, preserveAspectRatio: true, addShadow: true)
        } else {
            logoImageView.isHidden = true
            headlineTopConstraint.isActive = false
            headlineLabel.bottomAnchor.constraint(equalTo: footerLabel.topAnchor, constant: -40.0).isActive = true
            imageTopConstraint.isActive = false
            imageView.bottomAnchor.constraint(equalTo: headlineLabel.topAnchor, constant: -20.0).isActive = true
        }
        
        configure(imageView: imageView, imageName: promotion.image, preserveAspectRatio: !promotion.isImageFullSize, addShadow: false)
        
        if promotion.isImageFullSize {
            imageTopConstraint.isActive = false
            imageLeadingConstraint.constant = 0
            imageTrailingConstraint.constant = 0
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            imageView.contentMode = .scaleAspectFill
            view.sendSubview(toBack: imageView)
        } else {
            imageView.layer.borderWidth = 2.0
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.shadowOpacity = 0.7
            imageView.layer.shadowOffset = .init(width: 2.0, height: 2.0)
        }
    }
    
    @IBAction func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func configure(label: UILabel, styledText: StyledText, isUppercase: Bool) {
        label.text = isUppercase ? styledText.text.uppercased() : styledText.text
        label.textColor = UIColor(styledText.color)
        label.font = styledText.isBold ? .boldSystemFont(ofSize: label.font.pointSize) : .systemFont(ofSize: label.font.pointSize)
    }
    
    private func configure(imageView: UIImageView, imageName: String, preserveAspectRatio: Bool, addShadow: Bool) {
        let image = UIImage(named: imageName)!
        imageView.image = addShadow ? image.withShadow(blur: 3.0, offset: CGSize(width: 2.0, height: 2.0)) : image
        
        if preserveAspectRatio {
            let aspectRatioConstraint = NSLayoutConstraint(
                item: imageView,
                attribute: .width,
                relatedBy: .equal,
                toItem: imageView,
                attribute: .height,
                multiplier: image.size.width / image.size.height,
                constant: 0
            )
            
            imageView.addConstraint(aspectRatioConstraint)
        }
    }
    
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var footerLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var headlineTopConstraint: NSLayoutConstraint!
    @IBOutlet var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet var imageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var imageTrailingConstraint: NSLayoutConstraint!
}




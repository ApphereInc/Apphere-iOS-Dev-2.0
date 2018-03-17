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
    let spaceBetweenHeadlineAndFooterWhenNoLogo: CGFloat    = 40.0
    let spaceBetweenHeadlineAndImageWhenNoLogo: CGFloat     = 20.0
    let imageBorderColor: UIColor                           = .white
    let imageBorderWidth: CGFloat                           = 2.0
    let imageShadowColor: UIColor                           = .black
    let imageShadowOpacity: Float                           = 0.7
    let imageShadowOffset                                   = CGSize(width: 2.0, height: 2.0)
    let imageShadowBlur: CGFloat                            = 3.0
    let logoMaxHeight: CGFloat                              = 180.0
    let logoShadowColor: UIColor                            = .black
    let logoShadowOffset                                    = CGSize(width: 2.0, height: 2.0)
    let logoShadowBlur: CGFloat                             = 3.0
    
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
            configure(imageView: logoImageView, imageName: logo, preserveAspectRatio: true, maxHeight: logoMaxHeight, addShadow: true)
        } else {
            logoImageView.isHidden = true
            headlineTopConstraint.isActive = false
            imageTopConstraint.isActive = false
            imageBottomConstraint.isActive = false
            headlineLabel.bottomAnchor.constraint(equalTo: footerLabel.topAnchor, constant: -spaceBetweenHeadlineAndFooterWhenNoLogo).isActive = true
            
            if !promotion.isImageFullSize {
                imageView.topAnchor.constraint(equalTo: logoImageView.topAnchor).isActive = true
                imageView.bottomAnchor.constraint(equalTo: headlineLabel.topAnchor, constant: -spaceBetweenHeadlineAndImageWhenNoLogo).isActive = true
            }
        }
        
        configure(imageView: imageView, imageName: promotion.image, preserveAspectRatio: false, maxHeight: 0.0, addShadow: false)
        
        if promotion.isImageFullSize {
            imageTopConstraint.isActive = false
            imageBottomConstraint.isActive = false
            imageLeadingConstraint.constant = 0
            imageTrailingConstraint.constant = 0
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            imageView.contentMode = .scaleAspectFill
            view.sendSubview(toBack: imageView)
        } else {
            imageView.layer.borderWidth     = imageBorderWidth
            imageView.layer.borderColor     = imageBorderColor.cgColor
            imageView.layer.shadowColor     = imageShadowColor.cgColor
            imageView.layer.shadowOpacity   = imageShadowOpacity
            imageView.layer.shadowOffset    = imageShadowOffset
            imageView.layer.shadowRadius    = imageShadowBlur
        }
    }
    
    @IBAction func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func panGestureRecognized(_ gesture: UIPanGestureRecognizer) {
        // http://www.thorntech.com/2016/02/ios-tutorial-close-modal-dragging/
        
        let translation = gesture.translation(in: view).y
        let progress = min(max(translation / view.bounds.height, 0.0), 1.0)
        let interactor = ModalInteractor.shared
        
        switch gesture.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = (translation > 100.0)
            interactor.update(progress)
        case .ended:
            interactor.hasStarted = false
            
            if interactor.shouldFinish {
                interactor.finish()
            } else {
                interactor.cancel()
            }
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        default:
            break
        }
    }
    
    private func configure(label: UILabel, styledText: StyledText, isUppercase: Bool) {
        label.text = isUppercase ? styledText.text.uppercased() : styledText.text
        label.textColor = UIColor(styledText.color)
    }
    
    private func configure(imageView: UIImageView, imageName: String, preserveAspectRatio: Bool, maxHeight: CGFloat, addShadow: Bool) {
        let image = UIImage(named: imageName)!
        imageView.image = addShadow ? image.withShadow(blur: logoShadowBlur, color: logoShadowColor, offset: logoShadowOffset) : image
        
        if preserveAspectRatio {
            let aspectRatio = image.size.width / image.size.height
            
            if image.size.height / aspectRatio > maxHeight {
                imageView.heightAnchor.constraint(equalToConstant: maxHeight).isActive = true
            } else {
                let aspectRatioConstraint = NSLayoutConstraint(
                    item: imageView,
                    attribute: .width,
                    relatedBy: .equal,
                    toItem: imageView,
                    attribute: .height,
                    multiplier: aspectRatio,
                    constant: 0
                )
                
                imageView.addConstraint(aspectRatioConstraint)
            }
        }
    }
    
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var footerLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var headlineTopConstraint: NSLayoutConstraint!
    @IBOutlet var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet var imageBottomConstraint: NSLayoutConstraint!
    @IBOutlet var imageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var imageTrailingConstraint: NSLayoutConstraint!
}




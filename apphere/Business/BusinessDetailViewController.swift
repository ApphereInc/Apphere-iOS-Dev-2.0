//
//  BusinessDetailViewController.swift
//  apphere
//
//  Created by Tony Mann on 2/7/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit
import WebKit

class BusinessDetailViewController: UIViewController, StatusBarHideable, UIGestureRecognizerDelegate {
    var business: Business!
    var customerCounts: Database.CustomerCounts?
    
    override func viewDidLoad() {
        photoView.image                 = UIImage(named: business.photo)
        nameLabel.text                  = business.name.uppercased()
        promotionNameLabel.text         = business.promotion.name.uppercased()

        nameLabel.textColor = business.textColor
        promotionNameLabel.textColor = business.textColor
        urlButton.setTitle(business.url.host, for: .normal)
        
        update(label: activeCustomerCountLabel,  withCount: customerCounts?.active)
        update(label: dailyCustomerCountLabel,   withCount: customerCounts?.daily)
        update(label: totalCustomerCountLabel,   withCount: customerCounts?.total)
        update(label: phoneNumberLabel,          withText: business.phoneNumber)
        update(label: descriptionLabel,          withText: business.description)
        update(label: promotionDescriptionLabel, withText: business.promotion.description.text)
        
        webCamView.isHidden = true
        promotionPhotoView.isHidden = true
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized(_:)))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
        
        if let webCamId = business.webCamId {
            let html = webCamHtml(webCamId: webCamId)
            webCamView.loadHTMLString(html, baseURL: nil)
            webCamView.isHidden = false
        } else {
            promotionPhotoView.image = UIImage(named: business.promotion.image)
            promotionPhotoView.isHidden = false
        }
        
        Database.shared.getCustomerCounts(businessId: String(business.id)) { customerCounts, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.showError(error)
                }
                
                self.activeCustomerCountLabel.text   = String(customerCounts!.active)
                self.dailyCustomerCountLabel.text    = String(customerCounts!.daily)
                self.totalCustomerCountLabel.text    = String(customerCounts!.total)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        

    }
    
    var isStatusBarHidden = false
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer == panGestureRecognizer && otherGestureRecognizer == container.panGestureRecognizer
    }
    
    @objc func panGestureRecognized(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        if container.contentOffset.y > 0.0 {
            return
        }
        
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress: CGFloat = (translation.y / 200.0)
        progress = CGFloat(min(max(progress, 0.0), 1.0))
        
        switch gestureRecognizer.state {
        case .began:
            break
        case .changed:
            if swipeAnimator == nil {
                swipeAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .linear) {
                    self.view.layer.setAffineTransform(CGAffineTransform(scaleX: 0.8, y: 0.8))
                    self.view.layer.cornerRadius = 14.0
                    self.view.layer.masksToBounds = true
                    self.closeButton.alpha = 0.0
                }
            }
            
            swipeAnimator?.fractionComplete = progress
            
            if progress == 1.0 {
                swipeAnimator?.stopAnimation(true)
                swipeAnimator = nil
                dismiss(animated: true, completion: nil)
            }
        case .cancelled:
            swipeAnimator?.isReversed = true
            swipeAnimator?.startAnimation()
            swipeAnimator = nil
        case .ended:
            swipeAnimator?.isReversed = true
            swipeAnimator?.startAnimation()
            swipeAnimator = nil
        default:
            break
        }
    }
    
    @IBAction func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func urlButtonTapped() {
        UIApplication.shared.open(business.url, options: [:], completionHandler: nil)
    }
    
    private var swipeAnimator: UIViewPropertyAnimator?
    private var panGestureRecognizer: UIPanGestureRecognizer!
    
    private func update(label: UILabel, withText text: String?) {
        if let text = text {
            label.text = text
            label.isHidden = false
        } else {
            label.isHidden = true
        }
    }
    
    private func update(label: UILabel, withCount count: Int?) {
        label.text = count.map(String.init) ?? "-"
    }
    
    private func webCamHtml(webCamId: String) -> String {
        return """
        <html>
        <body bgcolor="black">
        <iframe
            type = "text/html"
            frameborder = "0"
            width = "100%"
            height = "100%"
            src = "https://video.nest.com/embedded/live/\(webCamId)?autoplay=1">
        </iframe>
        </body>
        </html>
        """
    }
    
    private func showError(_ error: Error) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showError(error as NSError)
    }
    
    @IBOutlet weak var container: UIScrollView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var urlButton: UIButton!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var promotionNameLabel: UILabel!
    @IBOutlet weak var activeCustomerCountLabel: UILabel!
    @IBOutlet weak var dailyCustomerCountLabel: UILabel!
    @IBOutlet weak var totalCustomerCountLabel: UILabel!
    @IBOutlet weak var promotionDescriptionLabel: UILabel!
    @IBOutlet weak var promotionPhotoView: UIImageView!
    @IBOutlet weak var webCamView: WKWebView!
    @IBOutlet weak var nameLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var photoHeightConstraint: NSLayoutConstraint!
}

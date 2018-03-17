//
//  BusinessListViewController.swift
//  apphere
//
//  Created by Derek Sheldon on 12/16/17.
//  Copyright © 2017 Derek Sheldon. All rights reserved.
//

import UIKit

class BusinessListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerTransitioningDelegate, StatusBarHideable {
    public var activeIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Notifications.authorize(confirmationViewController: self, completion: {_ in })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
  
        if let indexPath = activeIndexPath,
           let cell = collectionView.cellForItem(at: indexPath)
        {
            cell.contentView.layer.setAffineTransform(.identity)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "businessDetail" {
            let cell = sender as! BusinessCell
            activeIndexPath = collectionView.indexPath(for: cell)!
            let businessViewController = segue.destination as! BusinessDetailViewController
            businessViewController.business = BusinessDirectory.businesses[activeIndexPath!.item]
            businessViewController.customerCounts = cell.customerCounts
            businessViewController.transitioningDelegate = self
            let cellFrameInWindow = cell.convert(cell.bounds, to: nil)
            presentController.selectedBusinessCellFrameInWindow = cellFrameInWindow
            dismissController.selectedBusinessCellFrameInWindow = cellFrameInWindow
        }
    }
    
    var isStatusBarHidden = false
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = view.frame.width - 30.0
        layout.itemSize = CGSize(width: width, height: width * 1.2)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BusinessDirectory.businesses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "business", for: indexPath) as! BusinessCell
        cell.business = BusinessDirectory.businesses[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! BusinessListHeaderView
        header.date = Date()
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        
        UIView.animate(withDuration: 0.1) {
            cell.contentView.layer.setAffineTransform(CGAffineTransform(scaleX: 0.95, y: 0.95))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        
        UIView.animate(withDuration: 0.1) {
            cell.contentView.layer.setAffineTransform(.identity)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }

        UIView.animate(withDuration: 0.1, delay: 0.0, options: .beginFromCurrentState, animations: {
            cell.contentView.layer.setAffineTransform(CGAffineTransform(scaleX: 0.95, y: 0.95))
        }, completion: { _ in
            collectionView.deselectItem(at: indexPath, animated: false)
            self.performSegue(withIdentifier: "businessDetail", sender: cell)
        })
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissController
    }
    
    // MARK: - Outlets
    
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    let presentController = PresentBusinessViewAnimationController()
    let dismissController = DismissBusinessViewAnimationController()
}

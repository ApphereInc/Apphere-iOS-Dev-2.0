//
//  BusinessListViewController.swift
//  apphere
//
//  Created by Derek Sheldon on 12/16/17.
//  Copyright © 2017 Derek Sheldon. All rights reserved.
//

import UIKit

class BusinessListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerTransitioningDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "businessDetail" {
            let cell = sender as! BusinessCell
            let indexPath = collectionView.indexPath(for: cell)!
            let businessViewController = segue.destination as! BusinessDetailViewController
            businessViewController.business = BusinessDirectory.businesses[indexPath.item]
            businessViewController.transitioningDelegate = self
            presentBusinessViewAnimationController.selectedBusinessCellFrame = cell.frame
            dismissBusinessViewAnimationController.selectedBusinessCellFrame = cell.frame
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentBusinessViewAnimationController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissBusinessViewAnimationController
    }
    
    // MARK: - Outlets
    
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    let presentBusinessViewAnimationController = PresentBusinessViewAnimationController()
    let dismissBusinessViewAnimationController = DismissBusinessViewAnimationController()
}

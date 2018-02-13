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
            businessViewController.business = businesses[indexPath.item]
            businessViewController.transitioningDelegate = self
            presentBusinessViewAnimationController.selectedBusinessCellFrame = cell.frame
            dismissBusinessViewAnimationController.selectedBusinessCellFrame = cell.frame
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "business", for: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.item]
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

    var businesses: [Business] = [
        Business(photo: UIImage(named: "sweet")!,
              name: "sweet ride ice cream",
              promotion: "free holiday scoop",
              activeCustomerCount: 12,
              dailyCustomerCount: 48,
              totalCustomerCount: 2020,
              address1: "542 Penn Ave",
              address2: nil,
              city: "West Reading",
              state: "PA",
              zip: "19611",
              phoneNumber: "(484) 987-7338"
        ),
        Business(photo: UIImage(named: "red")!,
              name: "red robin exeter",
              promotion: "15% off all burgers",
              activeCustomerCount: 20,
              dailyCustomerCount: 62,
              totalCustomerCount: 4467,
              address1: "111 Main St",
              address2: nil,
              city: "West Reading",
              state: "PA",
              zip: "19611",
              phoneNumber: "(484) 367-9318"
        )
    ]
}

//
//  BusinessListViewController.swift
//  apphere
//
//  Created by Derek Sheldon on 12/16/17.
//  Copyright © 2017 Derek Sheldon. All rights reserved.
//

import UIKit

class BusinessListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate, StatusBarHideable {
    public var activeIndexPath: IndexPath?
    public var category: Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Notifications.authorize(confirmationViewController: self, completion: {_ in })
        category = category ?? Category.home
        addSections()
        
        configureNavigationBar()
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
        switch segue.identifier {
        case "businessDetail":
            let cell = sender as! BusinessCell
            activeIndexPath = collectionView.indexPath(for: cell)!
            let businessViewController = segue.destination as! BusinessDetailViewController
            businessViewController.business = BusinessDirectory.businesses[activeIndexPath!.item]
            businessViewController.customerCounts = cell.customerCounts
            businessViewController.rating = cell.rating
            businessViewController.transitioningDelegate = self
            let cellFrameInWindow = cell.convert(cell.bounds, to: nil)
            presentController.selectedBusinessCellFrameInWindow = cellFrameInWindow
            dismissController.selectedBusinessCellFrameInWindow = cellFrameInWindow
        case "category":
            let cell = sender as! CategoryCell
            let indexPath = collectionView.indexPath(for: cell)!
            let businessListController = segue.destination as! BusinessListViewController
            businessListController.category = category.subcategories[indexPath.item]
        default:
            break
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
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case categoriesSection:
            return category.subcategories.count
        case featuredSection:
            return category.featuredIds.count
        case allSection:
            return category.allIds.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == categoriesSection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "category", for: indexPath) as! CategoryCell
            cell.category = category.subcategories[indexPath.item]
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "business", for: indexPath) as! BusinessCell
        cell.business = BusinessDirectory.businesses[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case categoriesSection:
            return CategoryCell.size
        case featuredSection, allSection:
            return BusinessCell.size(frame: view.frame)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case categoriesSection:
            return UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        case featuredSection, allSection:
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 20.0, right: 0.0)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case categoriesSection:
            return 12.0
        case featuredSection, allSection:
            return 10.0
        default:
            return 0.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case categoriesSection:
            return 20.0
        case featuredSection, allSection:
            return 30.0
        default:
            return 0.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! BusinessListHeaderView
        
        switch indexPath.section {
        case categoriesSection:
            header.title = ""
        case featuredSection:
            header.title = "Featured Business"
        case allSection:
            header.title = "All \(category.title) Results"
        default:
            break
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case featuredSection, allSection:
            return CGSize(width: 0.0, height: 50.0)
        default:
            return .zero
        }
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
        guard indexPath.section != categoriesSection, let cell = collectionView.cellForItem(at: indexPath) else {
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
    
    // MARK: - Private
    
    private func addSections() {
        if !category.subcategories.isEmpty {
            categoriesSection = sectionCount
            sectionCount += 1
        }
        
        if !category.featuredIds.isEmpty {
            featuredSection = sectionCount
            sectionCount += 1
        }
        
        if !category.allIds.isEmpty {
            allSection = sectionCount
            sectionCount += 1
        }
    }
    
    private func configureNavigationBar() {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 128.0, height: 48.0))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 128.0, height: 38.0))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")!
        titleView.addSubview(imageView)
        navigationItem.titleView = titleView
    }
    
    
    private var sectionCount = 0
    private var categoriesSection = -1
    private var featuredSection = -1
    private var allSection = -1
}

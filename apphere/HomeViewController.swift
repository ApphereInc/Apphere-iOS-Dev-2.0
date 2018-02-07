//
//  HomeViewController.swift
//  apphere
//
//  Created by Derek Sheldon on 12/16/17.
//  Copyright © 2017 Derek Sheldon. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "business" {
            let cell = sender as! BusinessCell
            let indexPath = collectionView.indexPath(for: cell)!
            let businessViewController = segue.destination as! BusinessViewController
            businessViewController.business = businesses[indexPath.item]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "business", for: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HeaderView
        header.date = Date()
        return header
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    var businesses: [Business] = [
        Business(photo: UIImage(named: "sweet")!,
              name: "sweet ride ice cream",
              promotion: "free holiday scoop",
              footerLargeText: "12",
              footerSmallText: "here now"),
        Business(photo: UIImage(named: "red")!,
              name: "red robin exeter",
              promotion: "15% off all burgers",
              footerLargeText: "31",
              footerSmallText: "dec")
    ]
}

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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "event", for: indexPath) as! EventCell
        cell.event = events[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HeaderView
        header.date = Date()
        return header
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    var events: [Event] = [
        Event(photo: UIImage(named: "sweet")!,
              headerTitle: "sweet ride ice cream",
              headerSubtitle: "free holiday scoop",
              footerTitle: "12",
              footerSubtitle: "here now"),
        Event(photo: UIImage(named: "red")!,
              headerTitle: "red robin exeter",
              headerSubtitle: "15% off all burgers",
              footerTitle: "31",
              footerSubtitle: "dec")
    ]
}

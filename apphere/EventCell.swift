//
//  EventCell.swift
//  apphere
//
//  Created by Tony Mann on 2/6/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit

class EventCell: UICollectionViewCell {
    var event: Event! {
        didSet {
            photoView.image          = event.photo
            headerTitleLabel.text    = event.headerTitle.uppercased()
            headerSubtitleLabel.text = event.headerSubtitle.uppercased()
            footerTitleLabel.text    = event.footerTitle.uppercased()
            footerSubtitleLabel.text = event.footerSubtitle.uppercased()
        }
    }
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var headerSubtitleLabel: UILabel!
    @IBOutlet weak var footerTitleLabel: UILabel!
    @IBOutlet weak var footerSubtitleLabel: UILabel!
}

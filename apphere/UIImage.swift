//
//  UIImage.swift
//  apphere
//
//  Created by Tony Mann on 2/28/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import UIKit

// https://stackoverflow.com/a/43426952/201828

extension UIImage {
    func withShadow(blur: CGFloat = 1.0, color: UIColor = UIColor(white: 0, alpha: 1), offset: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size.width + 2 * blur, height: size.height + 2 * blur), false, 0)
        let context = UIGraphicsGetCurrentContext()!
        context.setShadow(offset: offset, blur: blur, color: color.cgColor)
        draw(in: CGRect(x: blur - offset.width / 2, y: blur - offset.height / 2, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

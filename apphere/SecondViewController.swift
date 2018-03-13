//
//  SecondViewController.swift
//  apphere
//
//  Created by Derek Sheldon on 12/3/17.
//  Copyright © 2017 Derek Sheldon. All rights reserved.
//

import UIKit
import WebKit

class SecondViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pageView" {
            pageControllers = [
                storyboard!.instantiateViewController(withIdentifier: "featured1"),
                storyboard!.instantiateViewController(withIdentifier: "featured2")
            ]

            let pageViewController = segue.destination as! UIPageViewController
            pageViewController.dataSource = self
            pageViewController.delegate = self
            pageViewController.setViewControllers([pageControllers[0]], direction: .forward, animated: false, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pageControllers.index(of: viewController) else {
            preconditionFailure()
        }
        
        if index == 0 {
            return nil
        }
        
        return pageControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageControllers.index(of: viewController) else {
            preconditionFailure()
        }
        
        if index == pageControllers.endIndex - 1 {
            return nil
        }
        
        return pageControllers[index + 1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    var pageControllers: [UIViewController]!
}


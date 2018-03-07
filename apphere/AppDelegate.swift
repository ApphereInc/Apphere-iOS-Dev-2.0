//
//  AppDelegate.swift
//  apphere
//
//  Created by Derek Sheldon on 12/3/17.
//  Copyright © 2017 Derek Sheldon. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Notifications.setUp()
        
        let businessesWithBeacons = BusinessDirectory.businesses.filter{ $0.hasBeacon }
        BeaconMonitor.shared.monitor(businesses: businessesWithBeacons)
        BeaconMonitor.shared.listener = self
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    var rootViewController: UIViewController {
        let tabBarController = window!.rootViewController! as! UITabBarController
        return tabBarController.selectedViewController!
    }
}

extension AppDelegate: BeaconMonitorListener {
    func entered(business: Business) {
        var userInfo = [String: String]()
        
        userInfo["business_id"] = String(business.id)
        
        if let url = business.promotion.url {
            userInfo["url"] = url
        }
        
        let notification = Notification(
            identifier: "entered-\(business.id)",
            title: "", message: "Open to see a special offer from \(business.name)",
            userInfo: userInfo,
            fireTime: .timeInterval(1.0),
            isRepeating: false,
            category: nil
        )
        
        Notifications.add(notification: notification)
    }
    
    func exited(business: Business) {}
    
    func monitoringFailed(error: NSError) {
        let alert = UIAlertController(
            title: "Beacon Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
        rootViewController.present(alert, animated: true, completion: nil)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        showPromotionView(for: notification, animated: true)
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            showPromotionView(for: response.notification, animated: false)
        }
    }
    
    private func showPromotionView(for notification: UNNotification, animated: Bool) {
        let userInfo = notification.request.content.userInfo as! [String: String]
        
        if let urlString = userInfo["url"], let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return
        }
        
        let presentingViewController = rootViewController
        let promotionViewController = presentingViewController.storyboard!.instantiateViewController(withIdentifier: "promotion") as! PromotionViewController
        
        guard let businessIdString = userInfo["business_id"],
              let businessId = Int(businessIdString),
              let business = BusinessDirectory.businesses.first(where: { $0.id == businessId })
        else {
            return
        }
        
        promotionViewController.business = business
        presentingViewController.present(promotionViewController, animated: animated, completion: nil)
    }
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let notification = Notification(identifier: "test", title: "", message: "Testing", userInfo: ["business_id": "1"], fireTime: .timeInterval(1.0), isRepeating: false, category: nil)
            Notifications.add(notification: notification)
        }
    }
}


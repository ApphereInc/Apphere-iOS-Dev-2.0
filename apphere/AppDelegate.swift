//
//  AppDelegate.swift
//  apphere
//
//  Created by Derek Sheldon on 12/3/17.
//  Copyright © 2017 Derek Sheldon. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Notifications.setUp()
        
        let zones = BusinessDirectory.businesses.filter{ $0.hasBeacon }.map {
            return Zone(name: $0.name, key: "business_id", value: String($0.id), radius: 1.0)
        }
        
        BeaconMonitor.shared.monitor(zones: zones)
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
    
    func entered(zone: Zone, beacon: Beacon) {
        let notification = Notification(identifier: "entered-\(zone.name)", title: "", message: "Open to see a special offer from \(zone.name)", userInfo: [zone.key: zone.value], fireTime: .timeInterval(1.0), isRepeating: false, category: nil)
        Notifications.add(notification: notification)
    }
    
    func exited(zone: Zone, beacon: Beacon) {}
    func moved(zone: Zone, beacons: [Beacon]) {}
    
    func beaconError(_ error: NSError) {
        let message: String
        
        switch error.code {
        case BeaconMonitorErrorCode.noBeaconsForZone.rawValue:
            message = "At least one business that is enabled for proximity monitoring has no beacons assigned to it."
        default:
            message = error.localizedDescription
        }
        
        let alert = UIAlertController(
            title: "Beacon Error",
            message: message,
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
        let presentingViewController = rootViewController
        let promotionViewController = presentingViewController.storyboard!.instantiateViewController(withIdentifier: "promotion") as! PromotionViewController
        
        let userInfo = notification.request.content.userInfo as! [String: String]
        let businessId = Int(userInfo["business_id"]!)
        
        guard let business = BusinessDirectory.businesses.first(where: { $0.id == businessId }) else {
            return
        }
        
        promotionViewController.business = business
        presentingViewController.present(promotionViewController, animated: animated, completion: nil)
    }
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let notification = Notification(identifier: "test", title: "", message: "Testing", userInfo: ["business_id": "8"], fireTime: .timeInterval(3.0), isRepeating: false, category: nil)
            Notifications.add(notification: notification)
        }
    }
}


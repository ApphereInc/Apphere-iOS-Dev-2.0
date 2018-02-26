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
            return Zone(name: $0.name, key: "business", value: $0.name, radius: 1.0)
        }
        
        BeaconMonitor.shared.monitor(zones: zones)
        BeaconMonitor.shared.listener = self
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
}

extension AppDelegate: BeaconMonitorListener {
    func entered(zone: Zone, beacon: Beacon) {
        addNotification(for: zone, isEntering: true)
    }
    
    func exited(zone: Zone, beacon: Beacon) {
        addNotification(for: zone, isEntering: false)
    }
    
    func moved(zone: Zone, beacons: [Beacon]) {}
    
    private func addNotification(for zone: Zone, isEntering: Bool) {
        let identifierPrefix = isEntering ? "entered" : "exited"
        let messagePrefix = isEntering ? "Entered" : "Exited"
        let notification = Notification(identifier: "\(identifierPrefix)-\(zone.name)", title: "", message: "\(messagePrefix) \(zone.name)", userInfo: [zone.key: zone.value], fireTime: .timeInterval(1.0), isRepeating: false, category: nil)
        Notifications.add(notification: notification)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let tabBarController = window!.rootViewController! as! UITabBarController
        let presentingViewController = tabBarController.selectedViewController!
        let promotionViewController = presentingViewController.storyboard!.instantiateViewController(withIdentifier: "promotion") as! PromotionViewController
        
        let userInfo = notification.request.content.userInfo as! [String: String]
        let businessName = userInfo["business"]
        
        guard let business = BusinessDirectory.businesses.first(where: { $0.name == businessName }) else {
            completionHandler([])
            return
        }
        
        promotionViewController.business = business
        
        presentingViewController.present(promotionViewController, animated: true) {
            completionHandler([])
        }
    }
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let notification = Notification(identifier: "test", title: "", message: "Testing", userInfo: ["business": BusinessDirectory.businesses.first!.name], fireTime: .timeInterval(1.0), isRepeating: false, category: nil)
            Notifications.add(notification: notification)
        }
    }
}


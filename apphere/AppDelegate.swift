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
        let notification = Notification(identifier: "entered-\(zone.name)", title: "", message: "Entered \(zone.name)", fireTime: .timeInterval(1.0), isRepeating: false, category: nil)
        Notifications.add(notification: notification)
    }
    
    func exited(zone: Zone, beacon: Beacon) {
        let notification = Notification(identifier: "exited-\(zone.name)", title: "", message: "Exited \(zone.name)", fireTime: .timeInterval(1.0), isRepeating: false, category: nil)
        Notifications.add(notification: notification)
    }
    
    func moved(zone: Zone, beacons: [Beacon]) {}
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}



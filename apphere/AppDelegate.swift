//
//  AppDelegate.swift
//  apphere
//
//  Created by Derek Sheldon on 12/3/17.
//  Copyright © 2017 Derek Sheldon. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Notifications.setUp()
        
        let zones = BusinessDirectory.businesses.map {
            return Zone(name: "", key: "business", value: $0.name, radius: 1.0)
        }
        
        BeaconMonitor.shared.monitor(zones: zones)
        BeaconMonitor.shared.listener = self
        
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



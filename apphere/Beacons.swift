//
//  Beacons.swift
//  apphere
//
//  Created by Tony Mann on 2/23/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import Foundation
import CoreLocation

protocol BeaconMonitorListener {
    func entered(business: Business)
    func exited(business: Business)
    func monitoringFailed(error: NSError)
}

@objc class BeaconMonitor: NSObject, CLLocationManagerDelegate {
    static var shared = BeaconMonitor()
    var listener: BeaconMonitorListener?
    
    func configure() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        
        beaconRegion = CLBeaconRegion(
            proximityUUID: proximityUUID,
            identifier: "apphere"
        )
        
        print("Start monitoring")
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.requestState(for: beaconRegion)
    }
    
    // MARK: Location Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print(#function)
        
        guard region.identifier == beaconRegion.identifier else {
            return
        }
        
        for beacon in beacons {
            let proximityString: String
            
            switch beacon.proximity {
            case .immediate:
                proximityString = "immediate"
            case .near:
                proximityString = "near"
            case .far:
                proximityString = "far"
            case .unknown:
                proximityString = "unknown"
            }
            
            print("Beacon major=", beacon.major.intValue, " accuracy=", beacon.accuracy, " proximity=", proximityString)
        }
        
        if let nearestBeacon = beacons.first {
            print("Nearest beacon, major = \(nearestBeacon.major.intValue)")
            
            switch nearestBeacon.proximity {
            case .immediate, .near:
                print("Beacon is near or immediate, major = \(nearestBeacon.major.intValue)")
                activeBeacon = nearestBeacon
            case .far:
                print("Beacon is far, major = \(nearestBeacon.major.intValue)")
                activeBeacon = nil
            case .unknown:
                print("Beacon proximity is unknown, major = \(nearestBeacon.major.intValue)")
            }
        } else {
            print("No beacons nearby")
            activeBeacon = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        print(#function)
        
        guard region.identifier == beaconRegion.identifier else {
            return
        }
        
        if state == .inside {
            print("Moved inside of region")
            
            if !isRanging {
                print("Start ranging")
                manager.startRangingBeacons(in: beaconRegion)
                isRanging = true
            }
        } else {
            print("Moved outside of region")
            
            if isRanging {
                print("Stop ranging")
                manager.stopRangingBeacons(in: beaconRegion)
                isRanging = false
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        self.listener?.monitoringFailed(error: error as NSError)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.listener?.monitoringFailed(error: error as NSError)
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        self.listener?.monitoringFailed(error: error as NSError)
    }
    
    // MARK: Private
    
    private var locationManager: CLLocationManager!
    
    private var beaconRegion: CLBeaconRegion!
    private var isRanging = false
    
    private var activeBeacon: CLBeacon? {
        didSet {
            if activeBeacon?.major == oldValue?.major {
                return
            }
            
            if let oldActiveBeacon = oldValue, let oldActiveBusiness = business(from: oldActiveBeacon) {
                print("Exited \(oldActiveBusiness.name), major = \(oldActiveBeacon.major.intValue)")
                listener?.exited(business: oldActiveBusiness)
            }
            
            if let activeBeacon = self.activeBeacon, let activeBusiness = business(from: activeBeacon) {
                print("Entered \(activeBusiness.name), major = \(activeBeacon.major.intValue)")
                listener?.entered(business: activeBusiness)
            }
        }
    }
    
    private func business(from beacon: CLBeacon) -> Business? {
        if let business = BusinessDirectory.get(withID: beacon.major) {
            return business
        }
        
        print("Business not found for major = \(beacon.major)")
        return nil
    }
    
    private let proximityUUID = UUID(uuidString: "41786AA2-86D6-F55A-0515-EACFD49E1378")!
}



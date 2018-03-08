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
        locationManager.requestAlwaysAuthorization()
        
        beaconRegion = CLBeaconRegion(
            proximityUUID: proximityUUID,
            identifier: "apphere"
        )
        
        print("Start monitoring")
        locationManager.startMonitoring(for: beaconRegion)
    }
    
    // MARK: Location Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print(#function)
        
        guard region.identifier == beaconRegion.identifier else {
            print("Not our region")
            return
        }
        
        guard CLLocationManager.isRangingAvailable() else {
            print("Ranging not available")
            return
        }
        
        print("Start ranging")
        
        if !isRanging {
            manager.startRangingBeacons(in: beaconRegion)
            isRanging = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print(#function)
        
        guard region.identifier == beaconRegion.identifier else {
            print("Not our region")
            return
        }
        
        print("Stop ranging")
        
        if isRanging {
            manager.stopRangingBeacons(in: beaconRegion)
            isRanging = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print(#function)
        
        guard region.identifier == beaconRegion.identifier else {
            print("Not our region")
            return
        }
        
        if let nearestBeacon = beacons.first, nearestBeacon.proximity != .far {
            print("Found nearby beacon")
            activeBeacon = nearestBeacon
        } else {
            print("No nearby beacons")
            activeBeacon = nil
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
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print(#function)
        
        guard region.identifier == beaconRegion.identifier else {
            print("Not our region")
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        print(#function)
        
        guard region.identifier == beaconRegion.identifier else {
            print("Not our region")
            return
        }
        
        print(state.rawValue == 1 ? "inside" : "outside")
        
        switch state {
        case .inside:
            if !isRanging {
                manager.startRangingBeacons(in: beaconRegion)
                isRanging = true
            }
        default:
            if isRanging {
                manager.stopRangingBeacons(in: beaconRegion)
                isRanging = false
            }
        }
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
                print("exited")
                listener?.exited(business: oldActiveBusiness)
            }
            
            if let activeBeacon = self.activeBeacon, let activeBusiness = business(from: activeBeacon) {
                print("entered")
                listener?.entered(business: activeBusiness)
            }
        }
    }
    
    private func business(from beacon: CLBeacon) -> Business? {
        print(#function, beacon.major)
        
        if let business = BusinessDirectory.get(withID: beacon.major) {
            print(business.name)
            return business
        }
        
        print("Not found")
        return nil
    }
    
    private let proximityUUID = UUID(uuidString: "41786AA2-86D6-F55A-0515-EACFD49E1378")!
}



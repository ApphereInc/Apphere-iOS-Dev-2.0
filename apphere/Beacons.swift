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
    var listeners = [BeaconMonitorListener]()
    
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
        locationManager.requestState(for: beaconRegion)
    }
    
    // MARK: Location Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print(#function)
        
        guard region.identifier == beaconRegion.identifier else {
            return
        }
        
        var businessIdsForCurrentBeaconZones = Set<Int>()
        
        for beacon in beacons where beacon.proximity != .unknown {
            let businessId = beacon.major.intValue
            businessIdsForCurrentBeaconZones.insert(businessId)
            
            var beaconZone: BeaconZone
            
            if let activeBeaconZone = activeBeaconZones[businessId] {
                beaconZone = activeBeaconZone
                print("Moved within beacon zone, businessId=\(beaconZone.businessId), proximity=\(beacon.proximity.string)")
            } else {
                beaconZone = BeaconZone(businessId: businessId)
                print("Entered beacon zone, businessId=\(beaconZone.businessId), proximity=\(beacon.proximity.string)")
            }
            
            beaconZone.proximity = beacon.proximity
            activeBeaconZones[businessId] = beaconZone
        }
        
        for var beaconZone in activeBeaconZones.values where !businessIdsForCurrentBeaconZones.contains(beaconZone.businessId) {
            print("Exited beacon zone, businessId=\(beaconZone.businessId)")
            beaconZone.exitTime = Date()
        }
        
        updateActiveBusinessState()
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        listeners.forEach { $0.monitoringFailed(error: error as NSError) }
    }
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        listeners.forEach { $0.monitoringFailed(error: error as NSError) }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        listeners.forEach { $0.monitoringFailed(error: error as NSError) }
    }
    
    // MARK: Private
    
    struct BeaconZone {
        let businessId: Int
        let enterTime = Date()
        var exitTime: Date?
        var proximity: CLProximity = .unknown
        
        init(businessId: Int) {
            self.businessId = businessId
        }
    }
    
    private var locationManager: CLLocationManager!
    private var beaconRegion: CLBeaconRegion!
    private var isRanging = false
    
    private var activeBusinessId: Int? {
        didSet {
            if activeBusinessId == oldValue {
                return
            }
            
            if let oldActiveBusinessId = oldValue, let oldActiveBusiness = business(from: oldActiveBusinessId) {
                print("Exited business \(oldActiveBusiness.name), businessId=\(oldActiveBusinessId)")
                listeners.forEach { $0.exited(business: oldActiveBusiness) }
            }
            
            if let activeBusinessId = self.activeBusinessId, let activeBusiness = business(from: activeBusinessId) {
                print("Entered business \(activeBusiness.name), businessId=\(activeBusinessId)")
                listeners.forEach { $0.entered(business: activeBusiness) }
            }
        }
    }
    
    private var activeBeaconZones = [Int: BeaconZone]()
    
    private func business(from businessId: Int) -> Business? {
        if let business = BusinessDirectory.get(withID: businessId) {
            return business
        }
        
        print("Business not found for businessId=\(businessId)")
        return nil
    }
    
    private func updateActiveBusinessState() {
        if let activeBusinessId = activeBusinessId {
            guard let beaconZone = activeBeaconZones[activeBusinessId] else {
                preconditionFailure()
            }
            
            if let exitTime = beaconZone.exitTime {
                let timeIntervalSinceExit = exitTime.timeIntervalSinceNow
                
                if timeIntervalSinceExit >= exitDelay {
                    self.activeBusinessId = nil
                    updateActiveBusinessState()
                } else {
                    Timer.scheduledTimer(withTimeInterval: exitDelay - timeIntervalSinceExit, repeats: false) { _ in
                        self.updateActiveBusinessState()
                    }
                }
            }
        } else {
            let eligibleBeaconZones = activeBeaconZones.values
                .filter { $0.enterTime.timeIntervalSinceNow > enterDelay }
                .sorted { $0.proximity.rawValue > $1.proximity.rawValue }
            
            if let eligibleBeaconZone = eligibleBeaconZones.first {
                activeBusinessId = eligibleBeaconZone.businessId
            }
        }
    }
    
    // TODO: remove active beacon zones exited over 5 minutes
    
    private let proximityUUID = UUID(uuidString: "41786AA2-86D6-F55A-0515-EACFD49E1378")!
    private let enterDelay: TimeInterval = 5.0
    private let exitDelay: TimeInterval = 10.0
}

extension CLProximity {
    var string: String {
        switch self {
        case .immediate:    return "immediate"
        case .near:         return "near"
        case .far:          return "far"
        case .unknown:      return "unknown"
        }
    }
}



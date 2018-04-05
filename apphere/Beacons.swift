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
        guard region.identifier == beaconRegion.identifier else {
            return
        }
        
        updateActiveBeaconZonesEnterStatus(beaconsInRange: beacons)
        updateActiveBeaconZonesExitStatus(beaconsInRange: beacons)
        updateActiveBusinessState()
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        guard region.identifier == beaconRegion.identifier else {
            return
        }
        
        if state == .inside && !isRanging {
            print("At least one beacon monitored, will start ranging")
            manager.startRangingBeacons(in: beaconRegion)
            isRanging = true
        } else if state == .outside && isRanging {
            print("No beacons monitored, will stop ranging")
            manager.stopRangingBeacons(in: beaconRegion)
            isRanging = false
            updateActiveBeaconZonesExitStatus(beaconsInRange: [])
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
    
    private struct BeaconZone {
        let businessId: Int
        var enterTime: Date?
        var exitTime: Date?
        var proximity: CLProximity = .unknown
        
        init(businessId: Int) {
            self.businessId = businessId
        }
    }
    
    private var locationManager: CLLocationManager!
    private var beaconRegion: CLBeaconRegion!
    private var isRanging = false
    private var activeBeaconZones = [Int: BeaconZone]()
    
    private var activeBusinessId: Int? {
        didSet {
            if activeBusinessId == oldValue {
                return
            }
            
            if let oldActiveBusinessId = oldValue, let oldActiveBusiness = business(from: oldActiveBusinessId) {
                print("Deactivated business \(oldActiveBusiness.name), businessId=\(oldActiveBusinessId)")
                listeners.forEach { $0.exited(business: oldActiveBusiness) }
            }
            
            if let activeBusinessId = self.activeBusinessId, let activeBusiness = business(from: activeBusinessId) {
                print("Activated business \(activeBusiness.name), businessId=\(activeBusinessId)")
                listeners.forEach { $0.entered(business: activeBusiness) }
            }
        }
    }
    
    private func business(from businessId: Int) -> Business? {
        if let business = BusinessDirectory.get(withID: businessId) {
            return business
        }
        
        print("Business not found for businessId=\(businessId)")
        return nil
    }
    
    private func updateActiveBusinessState() {
        if activeBusinessId == nil {
            activateBusinessIfNeeded()
        } else {
            deactivateBusinessIfNeeded()
        }
    }
    
    private func activateBusinessIfNeeded() {
        let enteredBeaconZones = activeBeaconZones.values.filter { $0.enterTime != nil}
        
        if enteredBeaconZones.isEmpty {
            return
        }
        
        print("Looking for eligible beacons...")
        
        let eligibleBeaconZones = enteredBeaconZones.filter { beaconZone in
            let timeIntervalSinceEnter = -beaconZone.enterTime!.timeIntervalSinceNow
            print("Beacon zone businessId=\(beaconZone.businessId) was entered \(timeIntervalSinceEnter) seconds ago")
            return timeIntervalSinceEnter > enterDelay
            }.sorted { $0.proximity.rawValue > $1.proximity.rawValue }
        
        if let eligibleBeaconZone = eligibleBeaconZones.first {
            activeBusinessId = eligibleBeaconZone.businessId
        } else {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                self.updateActiveBusinessState()
            }
        }
    }
    
    private func deactivateBusinessIfNeeded() {
        guard let activeBusinessId = activeBusinessId,
              let beaconZone = activeBeaconZones[activeBusinessId],
              let exitTime = beaconZone.exitTime
        else {
            return
        }
        
        let timeIntervalSinceExit = -exitTime.timeIntervalSinceNow
        print("Beacon zone businessId=\(beaconZone.businessId) has been exited for \(timeIntervalSinceExit) seconds")
        
        if timeIntervalSinceExit >= exitDelay {
            self.activeBusinessId = nil
            updateActiveBusinessState()
        } else {
            Timer.scheduledTimer(withTimeInterval: exitDelay - timeIntervalSinceExit, repeats: false) { _ in
                self.updateActiveBusinessState()
            }
        }
    }
    
    private func updateActiveBeaconZonesEnterStatus(beaconsInRange beacons: [CLBeacon]) {
        for beacon in beacons {
            if beacon.proximity == .unknown {
                continue
            }
            
            let businessId = beacon.major.intValue
            var beaconZone = activeBeaconZones[businessId] ?? BeaconZone(businessId: businessId)
            
            if beaconZone.enterTime == nil {
                if beacon.proximity == .far {
                    if beaconZone.proximity != beacon.proximity {
                        print("Is far from beacon zone, businessId=\(beaconZone.businessId)")
                    }
                } else {
                    beaconZone.enterTime = Date()
                    beaconZone.exitTime = nil
                    print("Entered beacon zone, businessId=\(beaconZone.businessId), proximity=\(beacon.proximity.string), time=\(beaconZone.enterTime!)")
                }
            } else if beaconZone.proximity != beacon.proximity {
                if beacon.proximity == .far {
                    print("Moved far from beacon zone, businessId=\(beaconZone.businessId)")
                } else if beacon.proximity == .far {
                    print("Moved back within beacon zone, businessId=\(beaconZone.businessId), proximity=\(beacon.proximity.string)")
                }
            }
            
            beaconZone.proximity = beacon.proximity
            activeBeaconZones[businessId] = beaconZone
        }
    }
    
    private func updateActiveBeaconZonesExitStatus(beaconsInRange beacons: [CLBeacon]) {
        let businessIds = Set(beacons.map { $0.major.intValue })
        
        for var beaconZone in activeBeaconZones.values where beaconZone.enterTime != nil {
            let beaconWasDetected = businessIds.contains(beaconZone.businessId)
            
            if beaconZone.proximity == .far || !beaconWasDetected {
                beaconZone.enterTime = nil
                beaconZone.exitTime = Date()
                print("Exited beacon zone, businessId=\(beaconZone.businessId), time=\(beaconZone.exitTime!)")
                activeBeaconZones[beaconZone.businessId] = beaconZone
            }
        }
    }
    
    // TODO: remove active beacon zones exited over 5 minutes
    
    private let proximityUUID = UUID(uuidString: "41786AA2-86D6-F55A-0515-EACFD49E1378")!
    private let enterDelay: TimeInterval = 1.0
    private let exitDelay: TimeInterval  = 5.0
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



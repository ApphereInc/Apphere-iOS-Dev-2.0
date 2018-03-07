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
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func monitor(businesses: [Business]) {
        regions = businesses.flatMap { business -> CLBeaconRegion? in
            guard let proximityUUID = business.proximityUUID else {
                return nil
            }
            
            let region = CLBeaconRegion(
                proximityUUID: UUID(uuidString: proximityUUID)!,
                identifier: String(business.id)
            )
            
            locationManager.startMonitoring(for: region)
            return region
        }
    }
    
    // MARK: Location Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let business = self.business(from: region) {
            self.listener?.entered(business: business)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let business = self.business(from: region) {
            self.listener?.exited(business: business)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        self.listener?.monitoringFailed(error: error as NSError)
    }
    
    // MARK: Private
    
    private let locationManager = CLLocationManager()
    private var regions = [CLBeaconRegion]()
    
    private func business(from region: CLRegion) -> Business? {
        if let region = region as? CLBeaconRegion, let business = BusinessDirectory.get(withUUID: region.proximityUUID) {
            return business
        }
        
        return nil
    }
}


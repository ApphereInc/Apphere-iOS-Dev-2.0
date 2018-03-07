//
//  Beacons.swift
//  apphere
//
//  Created by Tony Mann on 2/23/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import Foundation
import EstimoteProximitySDK

struct Beacon {
    init(deviceAttachment: EPXDeviceAttachment) {
        id = deviceAttachment.deviceIdentifier
        payload = deviceAttachment.payload as! [String: String]
    }
    
    var id: String
    var payload: [String: String]
}

typealias Meters = Double

protocol BeaconMonitorListener {
    func entered(business: Business, beacon: Beacon)
    func exited(business: Business, beacon: Beacon)
    func moved(business: Business, beacons: [Beacon])
    func beaconError(_ error: NSError)
}

@objc class BeaconMonitor: NSObject, ESTBeaconManagerDelegate {
    static var shared = BeaconMonitor()
    var listener: BeaconMonitorListener?
    
    override init() {
        super.init()
        ESTLogger.setConsoleLogLevel(ESTLogLevelVerbose)
        beaconManager.delegate = self
        beaconManager.requestAlwaysAuthorization()
    }
    
    func monitor(businesses: [Business], radius: Meters) {
        let proximityZones = businesses.map { business -> EPXProximityZone in
            let proximityZone = EPXProximityZone(
                range: EPXProximityRange.custom(desiredMeanTriggerDistance: radius)!,
                attachmentKey: "business_id",
                attachmentValue: String(business.id)
            )
            
            proximityZone.onEnterAction = { deviceAttachment in
                self.listener?.entered(business: business, beacon: Beacon(deviceAttachment: deviceAttachment))
            }
            
            proximityZone.onExitAction = { deviceAttachment in
                self.listener?.exited(business: business, beacon: Beacon(deviceAttachment: deviceAttachment))
            }
            
            proximityZone.onChangeAction = { deviceAttachments in
                self.listener?.moved(business: business, beacons: deviceAttachments.map(Beacon.init))
            }
            
            if let proximityUUID = business.proximityUUID {
                beaconManager.startRangingBeacons(in: CLBeaconRegion(
                    proximityUUID: UUID(uuidString: proximityUUID)!,
                    identifier: String(business.id)
                ))
            }
            
            return proximityZone
        }

        observer.startObserving(proximityZones)
    }
    
    // MARK: Beacon Manager Delegate
    
    func beaconManager(_ manager: Any, monitoringDidFailFor region: CLBeaconRegion?, withError error: Error) {
        self.listener?.beaconError(error as NSError)
    }
    
    // MARK: Private
    
    private lazy var observer = EPXProximityObserver(credentials: EPXCloudCredentials(appID: appId, appToken: appToken)) { error in
        self.listener?.beaconError(error as NSError)
    }
    
    private let beaconManager = ESTBeaconManager()
    
    private let appId = "apphere-p0d"
    private let appToken = "09f32257eb15a6937ed7447b110825eb"
}


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

enum BeaconMonitorErrorCode: Int {
    case noBeaconsForZone = 2 // EPXProximityObserverErrorNoAttachmentsMatchingZone
}

class BeaconMonitor {
    static var shared = BeaconMonitor()
    var listener: BeaconMonitorListener?
    
    init() {
        ESTConfig.setupAppID(appId, andAppToken: appToken)
        ESTAnalyticsManager.enableRangingAnalytics(true)
        ESTAnalyticsManager.enableMonitoringAnalytics(true)
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
    
    private lazy var observer = EPXProximityObserver(credentials: EPXCloudCredentials(appID: appId, appToken: appToken)) { error in
        self.listener?.beaconError(error as NSError)
    }
    
    private let beaconManager = ESTBeaconManager()
    
    private let appId = "apphere-p0d"
    private let appToken = "09f32257eb15a6937ed7447b110825eb"
}


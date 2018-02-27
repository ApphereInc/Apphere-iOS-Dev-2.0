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

struct Zone {
    let name: String
    let key: String
    let value: String
    let radius: Meters
}

protocol BeaconMonitorListener {
    func entered(zone: Zone, beacon: Beacon)
    func exited(zone: Zone, beacon: Beacon)
    func moved(zone: Zone, beacons: [Beacon])
    func beaconError(_ error: NSError)
}

enum BeaconMonitorErrorCode: Int {
    case noBeaconsForZone = 2 // EPXProximityObserverErrorNoAttachmentsMatchingZone
}

class BeaconMonitor {
    static var shared = BeaconMonitor()
    var listener: BeaconMonitorListener?
    
    init() {

    }
    
    func monitor(zones: [Zone]) {
        let proximityZones = zones.map { zone -> EPXProximityZone in
            let proximityZone = EPXProximityZone(
                range: EPXProximityRange.custom(desiredMeanTriggerDistance: zone.radius)!,
                attachmentKey: zone.key,
                attachmentValue: zone.value
            )
            
            proximityZone.onEnterAction = { deviceAttachment in
                self.listener?.entered(zone: zone, beacon: Beacon(deviceAttachment: deviceAttachment))
            }
            
            proximityZone.onExitAction = { deviceAttachment in
                self.listener?.exited(zone: zone, beacon: Beacon(deviceAttachment: deviceAttachment))
            }
            
            proximityZone.onChangeAction = { deviceAttachments in
                self.listener?.moved(zone: zone, beacons: deviceAttachments.map(Beacon.init))
            }
            
            return proximityZone
        }

        observer.startObserving(proximityZones)
    }
    
    private lazy var observer = EPXProximityObserver(credentials: credentials) { error in
        self.listener?.beaconError(error as NSError)
    }
    
    private let credentials = EPXCloudCredentials(appID: "apphere-p0d", appToken: "09f32257eb15a6937ed7447b110825eb")
}


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

protocol BeaconDetectorListener {
    func enteredRange(of beacon: Beacon)
    func exitedRange(of beacon: Beacon)
    func inRange(of beacons: [Beacon])
}

class BeaconDetector {
    static var shared = BeaconDetector()
    var listener: BeaconDetectorListener?
    
    init() {
        observer = EPXProximityObserver(credentials: credentials) { error in
            print("Error creating beacon proximity observer: \(error)")
        }
    }
    
    func detectBeacon(withKey key: String, andValue value: String, atDistance distance: Double) {
        let zone = EPXProximityZone(range: EPXProximityRange.custom(desiredMeanTriggerDistance: distance)!,
                                        attachmentKey: key,
                                        attachmentValue: value)
        
        zone.onEnterAction = { deviceAttachment in
            self.listener?.enteredRange(of: Beacon(deviceAttachment: deviceAttachment))
        }
        
        zone.onExitAction = { deviceAttachment in
            self.listener?.exitedRange(of: Beacon(deviceAttachment: deviceAttachment))
        }
        
        zone.onChangeAction = { deviceAttachments in
            self.listener?.inRange(of: deviceAttachments.map(Beacon.init))
        }
        
        zones.append(zone)
        observer.startObserving(zones)
    }
    
    private var observer: EPXProximityObserver
    private var zones = [EPXProximityZone]()
    private let credentials = EPXCloudCredentials(appID: "apphere-p0d", appToken: "09f32257eb15a6937ed7447b110825eb")
}


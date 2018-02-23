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

protocol BeaconDetectorDelegate {
    func enteredRange(of beacon: Beacon)
    func exitedRange(of beacon: Beacon)
    func inRange(of beacons: [Beacon])
}

class BeaconDetector {
    static var shared = BeaconDetector()
    var delegate: BeaconDetectorDelegate?
    
    init() {
        proximityObserver = EPXProximityObserver(credentials: credentials) { error in
            print("Error creating beacon proximity observer: \(error)")
        }
    }
    
    func observeBeacon(key: String, value: String, range: Double) {
        let zone = EPXProximityZone(range: EPXProximityRange.custom(desiredMeanTriggerDistance: range)!,
                                        attachmentKey: key,
                                        attachmentValue: value)
        
        zone.onEnterAction = { deviceAttachment in
            self.delegate?.enteredRange(of: Beacon(deviceAttachment: deviceAttachment))
        }
        
        zone.onExitAction = { deviceAttachment in
            self.delegate?.exitedRange(of: Beacon(deviceAttachment: deviceAttachment))
        }
        
        zone.onChangeAction = { deviceAttachments in
            self.delegate?.inRange(of: deviceAttachments.map(Beacon.init))
        }
    }
    
    private var proximityObserver: EPXProximityObserver
    private let credentials = EPXCloudCredentials(appID: "apphere-p0d", appToken: "09f32257eb15a6937ed7447b110825eb")
}


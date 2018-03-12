//
//  Database.swift
//  apphere
//
//  Created by Tony Mann on 3/12/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

class Database {
    static var shared = Database()
    
    struct Event: Codable {
        enum EventType: Int, Codable {
            case enter = 0
            case exit  = 1
        }
        
        let type: EventType
        let date: Date
        let businessId: String
    }
    
    struct Business: Codable {
        var activeCustomerCount: Int = 0
        
        enum CodingKeys: String, CodingKey {
            case activeCustomerCount = "active_customer_count"
        }
    }
    
    func add(event: Event, completion: @escaping (Any?, Error?) -> Void) {
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let businessDocument = self.db.collection("businesses").document(event.businessId)
            let businessSnapshot: DocumentSnapshot
            
            var business: Business
            
            do {
                try businessSnapshot = transaction.getDocument(businessDocument)
                
                if let oldBusinessData = businessSnapshot.data() {
                    business = try! FirestoreDecoder().decode(Business.self, from: oldBusinessData)
                } else {
                    business = Business()
                }
            } catch {
                business = Business()
            }
            
            switch event.type {
            case .enter:
                business.activeCustomerCount += 1
            case .exit:
                if business.activeCustomerCount > 0 {
                    business.activeCustomerCount -= 1
                }
            }
            
            let newBusinessData = try! FirestoreEncoder().encode(business)
            transaction.setData(newBusinessData, forDocument: businessDocument)

            let eventData = try! FirestoreEncoder().encode(event)
            let eventDocument = self.db.collection("events").document()
            transaction.setData(eventData, forDocument: eventDocument)
            
            return business
        }, completion: completion)
    }
    
    private lazy var db = Firestore.firestore()
}




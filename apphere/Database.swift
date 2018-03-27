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
        let userId: String
        
        enum CodingKeys: String, CodingKey {
            case type       = "type"
            case date       = "date"
            case businessId = "business_id"
            case userId     = "user_id"
        }
    }
    
    struct Rating: Codable {
        let value: Int
        let date: Date
        let businessId: String
        let userId: String
        
        enum CodingKeys: String, CodingKey {
            case value      = "value"
            case date       = "date"
            case businessId = "business_id"
            case userId     = "user_id"
        }
    }
    
    struct Business: Codable {
        var activeCustomerCount: Int = 0
        var totalCustomerCount: Int = 0
        var ratingCount: Int = 0
        var ratingTotal: Int = 0
        
        enum CodingKeys: String, CodingKey {
            case activeCustomerCount = "active_customer_count"
            case totalCustomerCount  = "total_customer_count"
            case ratingCount         = "rating_count"
            case ratingTotal         = "rating_total"
        }
        
        static let daysCollectionPath = "days"
        
        var rating: Int {
            if ratingCount == 0 {
                return 0
            }
            
            return ratingTotal / ratingCount
        }
    }
    
    struct Day: Codable {
        var customerCount: Int = 0
        
        enum CodingKeys: String, CodingKey {
            case customerCount = "customer_count"
        }
        
        static func path(from date: Date) -> String {
            let dateAtStartOfDay = Calendar.current.startOfDay(for: date)
            return String(dateAtStartOfDay.timeIntervalSince1970)
        }
    }
    
    struct CustomerCounts {
        var active: Int
        var daily: Int
        var total: Int
    }
    
    func add(event: Event, completion: @escaping (Any?, Error?) -> Void) {
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let businessDocument = self.db.collection("businesses").document(event.businessId)
            let dayDocument = self.dayDocument(for: businessDocument, at: event.date)
            
            var business: Business = self.decode(from: businessDocument, using: transaction) ?? Business()
            var day: Day = self.decode(from: dayDocument, using: transaction) ?? Day()
            
            switch event.type {
            case .enter:
                business.activeCustomerCount += 1
                business.totalCustomerCount  += 1
                day.customerCount            += 1
            case .exit:
                if business.activeCustomerCount > 0 {
                    business.activeCustomerCount -= 1
                }
            }
            
            let newBusinessData = try! FirestoreEncoder().encode(business)
            transaction.setData(newBusinessData, forDocument: businessDocument)
            
            let newDayData = try! FirestoreEncoder().encode(day)
            transaction.setData(newDayData, forDocument: dayDocument)

            let eventData = try! FirestoreEncoder().encode(event)
            let eventDocument = self.db.collection("events").document()
            transaction.setData(eventData, forDocument: eventDocument)
            
            return business
        }, completion: completion)
    }
    
    func add(rating: Rating, completion: @escaping (Any?, Error?) -> Void) {
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let businessDocument = self.db.collection("businesses").document(rating.businessId)
            var business: Business = self.decode(from: businessDocument, using: transaction) ?? Business()
            
            business.ratingTotal += rating.value
            business.ratingCount += 1
            
            let newBusinessData = try! FirestoreEncoder().encode(business)
            transaction.setData(newBusinessData, forDocument: businessDocument)
            
            let ratingData = try! FirestoreEncoder().encode(rating)
            let ratingDocument = self.db.collection("ratings").document()
            transaction.setData(ratingData, forDocument: ratingDocument)
            
            return business
        }, completion: completion)
    }
    
    func getCustomerCounts(businessId: String, completion: @escaping (CustomerCounts?, Error?) -> Void) {
        let businessDocument = self.db.collection("businesses").document(businessId)
        let dayDocument = self.dayDocument(for: businessDocument, at: Date())

        businessDocument.getDocument() { businessSnapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            let business: Business = self.decode(from: businessSnapshot!) ?? Business()
            
            dayDocument.getDocument() { daySnapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                let day: Day = self.decode(from: daySnapshot!) ?? Day()
                completion(CustomerCounts(active: business.activeCustomerCount, daily: day.customerCount, total: business.totalCustomerCount), nil)
            }
        }
    }
    
    func getRating(businessId: String, completion: @escaping (Int?, Error?) -> Void) {
        let businessDocument = self.db.collection("businesses").document(businessId)
        
        businessDocument.getDocument() { businessSnapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            let business: Business = self.decode(from: businessSnapshot!) ?? Business()
            completion(business.rating, nil)
        }
    }
    
    private func decode<T: Decodable>(from document: DocumentReference, using transaction: Transaction) -> T? {
        do {
            let snapshot = try transaction.getDocument(document)
            return self.decode(from: snapshot)
        } catch {
            return nil
        }
    }
    
    private func decode<T: Decodable>(from snapshot: DocumentSnapshot) -> T? {
        if let data = snapshot.data() {
            do {
                return try FirestoreDecoder().decode(T.self, from: data)
            } catch {}
        }
        
        return nil
    }
    
    private func dayDocument(for businessDocument: DocumentReference, at date: Date) -> DocumentReference {
        return businessDocument.collection(Business.daysCollectionPath).document(Day.path(from: date))
    }
    
    private lazy var db = Firestore.firestore()
}




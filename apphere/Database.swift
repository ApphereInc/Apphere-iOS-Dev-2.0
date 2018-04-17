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

    typealias CustomerCounts = (active: Int, daily: Int, total: Int)
    
    func addCustomer(userId: String, businessId: String, completion: @escaping (Any?, Error?) -> Void) {
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let businessDocument = self.db.collection("businesses").document(businessId)
            
            guard var business: Business = self.decode(from: businessDocument, using: transaction) else {
                return nil
            }
            
            let date = Date()
            let dayDocument = self.dayDocument(for: businessDocument, at: date)
            var day: Day = self.decode(from: dayDocument, using: transaction) ?? Day()
            
            business.customerStats.active += 1
            business.customerStats.total  += 1
            day.customerCount             += 1
            
            let newBusinessData = try! FirestoreEncoder().encode(business)
            transaction.setData(newBusinessData, forDocument: businessDocument)
            
            let newDayData = try! FirestoreEncoder().encode(day)
            transaction.setData(newDayData, forDocument: dayDocument)

            let customer = Customer(userId: userId, businessId: businessId, enterDate: date, exitDate: nil)
            let customerData = try! FirestoreEncoder().encode(customer)
            let customerDocument = self.db.collection("customers").document()
            transaction.setData(customerData, forDocument: customerDocument)
            
            return customer
        }, completion: completion)
    }
    
    func exitCustomer(userId: String, businessId: String, completion: @escaping (Any?, Error?) -> Void) {
        let customerQuery = self.db.collection("customers")
            .whereField("user_id", isEqualTo: userId)
            .whereField("business_id", isEqualTo: businessId)
            .order(by: "enter_date", descending: true)
            .limit(to: 1)

        customerQuery.getDocuments { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            let customerDocument = snapshot!.documents.first?.reference
            
            self.db.runTransaction({ (transaction, errorPointer) -> Any? in
                let businessDocument = self.db.collection("businesses").document(businessId)
                
                guard var business: Business = self.decode(from: businessDocument, using: transaction) else {
                    return nil
                }
                
                if let customerDocument = customerDocument,
                   var customer: Customer = self.decode(from: customerDocument, using: transaction)
                {
                    customer.exitDate = Date()
                    let customerData = try! FirestoreEncoder().encode(customer)
                    transaction.setData(customerData, forDocument: customerDocument)
                }
                
                if business.customerStats.active > 0 {
                    business.customerStats.active -= 1
                    let newBusinessData = try! FirestoreEncoder().encode(business)
                    transaction.setData(newBusinessData, forDocument: businessDocument)
                }
                
                return business.customerStats.active
            }, completion: completion)
        }
    }
    
    func add(rating: Rating, completion: @escaping (Any?, Error?) -> Void) {
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let businessDocument = self.db.collection("businesses").document(rating.businessId)
            
            guard var business: Business = self.decode(from: businessDocument, using: transaction) else {
                return nil
            }
            
            business.ratingStats.total += rating.value
            business.ratingStats.count += 1
            
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
            
            guard let business: Business = self.decode(from: businessSnapshot!) else {
                completion(nil, NSError(domain: "Database", code: 1, userInfo: nil))
                return
            }
            
            dayDocument.getDocument() { daySnapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                let day: Day = self.decode(from: daySnapshot!) ?? Day()
                completion(CustomerCounts(active: business.customerStats.active, daily: day.customerCount, total: business.customerStats.total), nil)
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
            
            guard let business: Business = self.decode(from: businessSnapshot!) else {
                completion(nil, NSError(domain: "Database", code: 1, userInfo: nil))
                return
            }
            
            completion(business.ratingStats.average, nil)
        }
    }
    
    private func decode<T: FirestoreCodable>(from document: DocumentReference, using transaction: Transaction) -> T? {
        do {
            let snapshot = try transaction.getDocument(document)
            return self.decode(from: snapshot)
        } catch {
            return nil
        }
    }
    
    private func decode<T: FirestoreCodable>(from snapshot: DocumentSnapshot) -> T? {
        if let data = snapshot.data() {
            do {
                let object = try FirestoreDecoder().decode(T.self, from: data)
                object.setDocumentId(snapshot.documentID)
                return object
            } catch {}
        }
        
        return nil
    }
    
    private func dayDocument(for businessDocument: DocumentReference, at date: Date) -> DocumentReference {
        let dateAtStartOfDay = Calendar.current.startOfDay(for: date)
        let dayPath = String(dateAtStartOfDay.timeIntervalSince1970)
        return businessDocument.collection("days").document(dayPath)
    }
    
    private lazy var db = Firestore.firestore()
}

extension RatingStats {
    var average: Int {
        if count == 0 {
            return 0
        }
        
        return total / count
    }
}




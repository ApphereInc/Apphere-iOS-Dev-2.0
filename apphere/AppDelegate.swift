//
//  AppDelegate.swift
//  apphere
//
//  Created by Derek Sheldon on 12/3/17.
//  Copyright © 2017 Derek Sheldon. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        #if !IOS_SIMULATOR
            BeaconMonitor.shared.configure()
            BeaconMonitor.shared.listener = self
        #endif
        
        Notifications.setUp()
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    var rootViewController: UIViewController {
        let tabBarController = window!.rootViewController! as! UITabBarController
        return tabBarController.selectedViewController!
    }
    
    func showError(_ error: NSError) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
        rootViewController.present(alert, animated: true, completion: nil)
    }
}

extension AppDelegate: BeaconMonitorListener {
    func entered(business: Business) {
        DispatchQueue.main.async {
            self.notify(with: business, forEventType: .enter)
        }
        
        addEventToDatabase(for: business, ofType: .enter)
    }
    
    func exited(business: Business) {
        DispatchQueue.main.async {
            self.notify(with: business, forEventType: .exit)
        }
        
        addEventToDatabase(for: business, ofType: .exit)
    }
    
    func monitoringFailed(error: NSError) {
        DispatchQueue.main.async {
            self.showError(error)
        }
    }
    
    private func addEventToDatabase(for business: Business, ofType type: Database.Event.EventType) {
        let event = Database.Event(type: type, date: Date(), businessId: String(business.id))
        
        Database.shared.add(event: event) { _, error in
            if let error = error {
                self.showError(error as NSError)
            }
        }
    }
    
    private func notify(with business: Business, forEventType eventType: Database.Event.EventType) {
        var userInfo = [String: String]()
        
        userInfo["business_id"] = String(business.id)
        userInfo["event_type"] = String(eventType.rawValue)
        
        if let url = business.promotion.url {
            userInfo["url"] = url
        }
        
        let message: String
        let eventTypeString: String
        
        switch eventType {
        case .enter:
            eventTypeString = "enter"
            message = "Open to see a special offer from \(business.name)"
        case .exit:
            eventTypeString = "exit"
            message = "Thank for you for visiting \(business.name)"
        }
        
        let notification = Notification(
            identifier: "\(eventTypeString)-\(business.id)",
            title: "",
            message: message,
            userInfo: userInfo,
            fireTime: .timeInterval(1.0),
            isRepeating: false,
            category: nil
        )
        
        Notifications.add(notification: notification)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        showNotificationView(notification: notification, animated: true)
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
           showNotificationView(notification: response.notification, animated: false)
        }
    }
    
    private func showNotificationView(notification: UNNotification, animated: Bool) {
        let userInfo = notification.request.content.userInfo as! [String: String]
        
        guard let eventTypeString = userInfo["event_type"],
            let eventTypeNumber = Int(eventTypeString),
            let eventType = Database.Event.EventType(rawValue: eventTypeNumber)
            else {
                return
        }
        
        guard let businessIdString = userInfo["business_id"],
            let businessId = Int(businessIdString),
            let business = BusinessDirectory.businesses.first(where: { $0.id == businessId })
        else {
            return
        }
        
        let url = userInfo["url"].flatMap { URL(string: $0) }
        
        switch eventType {
        case .enter:
            showPromotionView(business: business, url: url, animated: animated)
        case .exit:
            showExitView(business: business, animated: animated)
            break
        }
    }
    
    private func showPromotionView(business: Business, url: URL?, animated: Bool) {
        if let url = url, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return
        }
        
        let presentingViewController = rootViewController
        
        if presentingViewController.presentedViewController != nil {
            return
        }
        
        let promotionViewController = presentingViewController.storyboard!.instantiateViewController(withIdentifier: "promotion") as! PromotionViewController
        promotionViewController.transitioningDelegate = ModalTransitioningDelegate.shared
        
        promotionViewController.business = business
        presentingViewController.present(promotionViewController, animated: animated, completion: nil)
    }
    
    private func showExitView(business: Business, animated: Bool) {
        let presentingViewController = rootViewController
        
        if presentingViewController.presentedViewController != nil {
            return
        }
        
        let promotionViewController = presentingViewController.storyboard!.instantiateViewController(withIdentifier: "exit") as! ExitViewController
        promotionViewController.transitioningDelegate = ModalTransitioningDelegate.shared
        
        promotionViewController.business = business
        presentingViewController.present(promotionViewController, animated: animated, completion: nil)
    }
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let business = BusinessDirectory.businesses.first!
            
            appDelegate.entered(business: business)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
                appDelegate.exited(business: business)
            }
        }
    }
}


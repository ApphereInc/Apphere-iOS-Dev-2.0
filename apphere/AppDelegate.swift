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
    var shouldShowViewOnBeaconEvent = true

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        BeaconMonitor.shared.listeners.append(self)
        
        #if !IOS_SIMULATOR
            BeaconMonitor.shared.configure()
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
    func entered(business: BusinessUI) {
        DispatchQueue.main.async {
            self.notifyEnter(with: business)
        }
        
        addCustomer(for: business)
    }
    
    func exited(business: BusinessUI) {
        DispatchQueue.main.async {
            self.notifyExit(with: business)
        }
        
        exitCustomer(from: business)
    }
    
    func monitoringFailed(error: NSError) {
        DispatchQueue.main.async {
            self.showError(error)
        }
    }
    
    private func addCustomer(for business: BusinessUI) {
        Database.shared.addCustomer(userId: User.current.id, businessId: String(business.id)) { _, error in
            if let error = error {
                self.showError(error as NSError)
            }
        }
    }
    
    private func exitCustomer(from business: BusinessUI) {
        Database.shared.exitCustomer(userId: User.current.id, businessId: String(business.id)) { _, error in
            if let error = error {
                self.showError(error as NSError)
            }
        }
    }
    
    private func notifyEnter(with business: BusinessUI) {
        var userInfo = [String: String]()
        
        userInfo["business_id"] = String(business.id)
        userInfo["event_type"]  = "enter"
        
        if let url = business.promotion.url {
            userInfo["url"] = url
        }
        
        let notification = Notification(
            identifier: "enter-\(business.id)",
            title: "",
            message: "Open to see a special offer from \(business.name)",
            userInfo: userInfo,
            fireTime: .timeInterval(1.0),
            isRepeating: false,
            category: nil
        )
        
        Notifications.add(notification: notification)
    }
    
    private func notifyExit(with business: BusinessUI) {
        var userInfo = [String: String]()
        
        userInfo["business_id"] = String(business.id)
        userInfo["event_type"]  = "exit"
        
        if let url = business.promotion.url {
            userInfo["url"] = url
        }
        
        let notification = Notification(
            identifier: "exit-\(business.id)",
            title: "",
            message: "Thank for you for visiting \(business.name)",
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
        
        guard let eventType = userInfo["event_type"] else {
            return
        }
        
        guard let businessIdString = userInfo["business_id"],
            let businessId = Int(businessIdString),
            let business = BusinessDirectory.businesses.first(where: { $0.id == businessId })
        else {
            return
        }
        
        let url = userInfo["url"].flatMap { URL(string: $0) }
        
        if shouldShowViewOnBeaconEvent {
            switch eventType {
            case "enter":
                showPromotionView(business: business, url: url, animated: animated)
            case "exit":
                showExitView(business: business, animated: animated)
            default:
                break
            }
        }
    }
    
    private func showPromotionView(business: BusinessUI, url: URL?, animated: Bool) {
        if let url = url, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return
        }
        
        let presentingViewController = rootViewController
        
        if presentingViewController.presentedViewController != nil {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let promotionViewController = storyboard.instantiateViewController(withIdentifier: "promotion") as! PromotionViewController
        promotionViewController.transitioningDelegate = ModalTransitioningDelegate.shared

        promotionViewController.business = business
        presentingViewController.present(promotionViewController, animated: animated, completion: nil)
    }
    
    private func showExitView(business: BusinessUI, animated: Bool) {
        let presentingViewController = rootViewController
        
        if presentingViewController.presentedViewController != nil {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let exitViewController = storyboard.instantiateViewController(withIdentifier: "exit") as! ExitViewController
        exitViewController.transitioningDelegate = ModalTransitioningDelegate.shared
        
        exitViewController.business = business
        presentingViewController.present(exitViewController, animated: animated, completion: nil)
    }
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let business = BusinessDirectory.businesses.first!
            
            BeaconMonitor.shared.listeners.forEach { $0.entered(business: business) }

            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
                appDelegate.exited(business: business)
            }
        }
    }
}


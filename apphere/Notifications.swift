//
//  Notifications.swift
//
//  Created by Tony Mann on 2/1/18.
//  Copyright © 2018 7Actions Software. All rights reserved.
//

import UIKit
import UserNotifications

struct Notification {
    enum FireTime {
        case dateComponents(DateComponents)
        case timeInterval(TimeInterval)
        
        var string: String {
            switch self {
            case let .dateComponents(dateComponents):
                return FireTime.formatter.string(from: dateComponents)!
            case let .timeInterval(timeInterval):
                return "\(timeInterval)s"
            }
        }
        
        static var formatter: DateComponentsFormatter  = {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute, .second]
            return formatter
        }()
    }
    
    var identifier: String
    var title: String
    var message: String
    var userInfo:  [String: Any]
    var fireTime: FireTime
    var isRepeating: Bool
    var category: String?
}

class Notifications {
    static let handler = NotificationHandler()
    static let max = 64
    
    static func setUp() {
        center.delegate = handler
    }
    
    static func getAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        center.getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }
    
    static func authorize(confirmationViewController: UIViewController?, completion: @escaping (Bool) -> Void) {
        getAuthorizationStatus { authorizationStatus in
            DispatchQueue.main.async {
                switch authorizationStatus {
                case .notDetermined:
                    requestAuthorization(completion: completion)
                case .authorized:
                    completion(true)
                case .denied:
                    if let viewController = confirmationViewController {
                        requestReauthorization(viewController: viewController) {
                            completion(false)
                        }
                    } else {
                        openSettings()
                        completion(false)
                    }
                }
            }
        }
    }
    
    static func fetchPendingRequests(completion: @escaping ([String: UNNotificationRequest]) -> Void) {
        center.getPendingNotificationRequests { requests in
            var requestsDictionary = [String: UNNotificationRequest]()
            
            for request in requests {
                requestsDictionary[request.identifier] = request
            }
            
            completion(requestsDictionary)
        }
    }
    
    static func add(notification: Notification) {
        let trigger: UNNotificationTrigger
        
        switch notification.fireTime {
        case let .dateComponents(dateComponents):
            trigger = createDateTrigger(date: dateComponents, isRepeating: notification.isRepeating)
        case let .timeInterval(timeInterval):
            trigger = createTimeIntervalTrigger(timeInterval: timeInterval, isRepeating: notification.isRepeating)
        }
        
        addNotification(identifier: notification.identifier, title: notification.title, message: notification.message, userInfo: notification.userInfo, trigger: trigger, category: notification.category)
    }
    
    static func remove(withIdentifier identifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    static func removeAll() {
        center.removeAllPendingNotificationRequests()
    }
    
    static func createCategory(identifier: String, actions: [(title: String, identifier: String)]) -> UNNotificationCategory {
        let notificationActions = actions.map {
            UNNotificationAction(identifier:  $0.1, title: $0.0, options: [])
        }
        
        return UNNotificationCategory(identifier: identifier, actions: notificationActions, intentIdentifiers: [], options: [.customDismissAction])
    }
    
    static func setCategories(categories: Set<UNNotificationCategory>) {
        center.setNotificationCategories(categories)
    }
    
    // MARK: - Private
    
    private static var authorizationRequestInProgress = false
    private static let center = UNUserNotificationCenter.current()
    
    private static func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard !authorizationRequestInProgress else {
            return
        }
        
        authorizationRequestInProgress = true
        
        center.requestAuthorization(options:  [.alert, .sound, .badge]) { (granted, error) in
            authorizationRequestInProgress = false
            
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    private static func requestReauthorization(viewController: UIViewController, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Allow Notifications",
                                      message: "Please go to the app's Settings and turn on notifications.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            completion()
            self.openSettings()
        })
        
        alert.addAction(UIAlertAction(title: "Not Now", style: .cancel) { _ in
            completion()
        })
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    private static func openSettings() {
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
    }
    
    private static func addNotification(identifier: String, title: String, message: String, userInfo: [String: Any], trigger: UNNotificationTrigger, category: String? = nil) {
        let content = createContent(title: title, message: message, userInfo: userInfo, category: category)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    private static func createDateTrigger(date: DateComponents, isRepeating: Bool) -> UNNotificationTrigger {
        return UNCalendarNotificationTrigger(dateMatching: date, repeats: isRepeating)
    }
    
    private static func createTimeIntervalTrigger(timeInterval: TimeInterval, isRepeating: Bool) -> UNNotificationTrigger {
        guard timeInterval >= 1.0 else {
            preconditionFailure()
        }
        
        return UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: isRepeating)
    }
    
    private static func createContent(title: String, message: String, userInfo: [String: Any] = [:], category: String?) -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title       = title
        content.body        = message
        content.sound       = UNNotificationSound.default()
        content.userInfo    = userInfo
        
        if let category = category {
            content.categoryIdentifier = category
        }
        
        return content
    }
}

protocol NotificationHandlerDelegate {
    func notificationReceivedResponse(identifier: String, action: String)
}

class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    var delegate: NotificationHandlerDelegate?
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        delegate?.notificationReceivedResponse(identifier: response.notification.request.identifier, action: response.actionIdentifier)
        completionHandler()
    }
}




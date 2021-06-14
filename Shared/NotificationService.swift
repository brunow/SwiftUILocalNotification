//
//  NotificationService.swift
//  SwiftUINotification
//
//  Created by cesar4 on 14/06/2021.
//

import SwiftUI
import UserNotifications

enum NotificationCategories: String {
    case nearReminder = "NearReminderNotificationCategory"
    case dailySummary = "DailySummaryNotificationCategory"
}

class NotificationService: NSObject, ObservableObject {
    @Published var authorizationStatus: UNAuthorizationStatus = .notDetermined {
        didSet {
            #if os(watchOS)
            if authorizationStatus == .authorized {
                setCategories()
            }
            #elseif os(macOS)
            if authorizationStatus == .authorized {
                setCategories()
            }
            #else
            if authorizationStatus == .authorized || authorizationStatus == .ephemeral {
                setCategories()
            }
            #endif
        }
    }
    
    var grantedNotification: Bool { authorizationStatus == .authorized || authorizationStatus == .provisional }
    
    required override init() {
        super.init()
        
        UNUserNotificationCenter.current().delegate = self
        
        updateStatus()
        setCategories()
    }
    
    func askForNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge],
            completionHandler: { granted, _ in
                if granted {
                    UNUserNotificationCenter.current().getNotificationSettings { settings in
                        DispatchQueue.main.async {
                            self.authorizationStatus = settings.authorizationStatus
                        }
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.authorizationStatus = .denied
                    }
                }
            })
    }
    
    func updateStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
        }
    }
}

// MARK: Private
private extension NotificationService {
    func setCategories() {
        let nearReminderCategory = UNNotificationCategory(
            identifier: NotificationCategories.nearReminder.rawValue,
            actions: [],
            intentIdentifiers: [],
            options: [])
        
        let categories: Set<UNNotificationCategory> = [nearReminderCategory]
        UNUserNotificationCenter.current().setNotificationCategories(categories)
    }
}

// MARK: UNUserNotificationCenterDelegate
extension NotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler( [.list, .badge, .sound, .banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
}

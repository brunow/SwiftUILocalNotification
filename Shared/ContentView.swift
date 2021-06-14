//
//  ContentView.swift
//  Shared
//
//  Created by cesar4 on 14/06/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Button("Test notification", action: sendNotification)
    }
    
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Nearby"
        content.body = "You have 3 reminders to do"
        content.categoryIdentifier = NotificationCategories.nearReminder.rawValue
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

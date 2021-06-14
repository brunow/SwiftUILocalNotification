//
//  SwiftUINotificationApp.swift
//  Shared
//
//  Created by cesar4 on 14/06/2021.
//

import SwiftUI

@main
struct SwiftUINotificationApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject var notificationService = NotificationService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .accentColor(.blue)
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                appDidBecomeActive()
            default:
                break
            }
        }
    }
    
    func appDidBecomeActive() {
        notificationService.askForNotificationPermissions()
    }
}

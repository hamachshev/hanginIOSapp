//
//  RequestNotifictationView.swift
//  hangin
//
//  Created by Aharon Seidman on 11/16/24.
//

import SwiftUI
import KeychainSwift

struct RequestNotifictationView: View {
    var body: some View {
        Button(action: {requestNotifications()}) {
            Text("Allow notifications")
        }
    }
    
    func requestNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { allowed, error in
            if allowed {
                print("Notifications allowed")
                KeychainSwift().set(true, forKey: "NotificationsAllowed")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notifications not allowed")
            }
        }
    }
}

#Preview {
    RequestNotifictationView()
}

//
//  hanginApp.swift
//  hangin
//
//  Created by Aharon Seidman on 9/12/24.
//

import SwiftUI
import KeychainSwift

@main
struct hanginApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    var body: some Scene {
        WindowGroup {
//            OnboardingView().background(Color("background"))
            if KeychainSwift().get("accessToken") != nil {
//                NavigationStack {
//                    MainScreen()
//                }
//                ContactsImport()
                RequestNotifictationView()

            } else {
                OnboardingView()
            }
        }
    }
}

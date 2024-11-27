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
    @State private var router = Router()
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        appDelegate.router = router
    }
    
    var body: some Scene {
        WindowGroup {
//            OnboardingView().background(Color("background"))
            if KeychainSwift().get("accessToken") != nil {
                NavigationStack(path: $router.path) {
                    MainScreen(path: $router.path)
                        
                        .navigationDestination(for: String.self) { route in
                            if route == "messageBox"{
                                MessageBoxView()
                            }
                        }
                }
//                ContactsImport()
//                RequestNotifictationView()

            } else {
                OnboardingView()
            }
        }

        .onChange(of: scenePhase) { oldPhase, phase in
            print("old phase \(oldPhase)")
            switch phase {
                
            case .background:
                print("background----------------------------------------------------------------")
                WebsocketManager.shared.goToBackground()
            case .inactive:
                print("inactive------------------------------------------------------------------")
            case .active:
                print("active--------------------------------------------------------------------")
                WebsocketManager.shared.startConnection()
            @unknown default:
                print("default?----------------------------------------------------------------")
            }
        }
    }
}

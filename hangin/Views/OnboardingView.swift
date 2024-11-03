//
//  OnboardingView.swift
//  hangin
//
//  Created by Aharon Seidman on 9/18/24.
//

import SwiftUI
import KeychainSwift

struct OnboardingView: View {
    @State private var text: String = ""
    @State private var confirmCodeScreen: Bool = (KeychainSwift().get("accessToken") != nil) ? true : false

    

    var body: some View {
        NavigationStack {
            VStack {
                Text("welcome to hangin'")
                
                TextField("Enter your number", text: $text)
                Button {
                    var url: URL {
                        var components = URLComponents(string: "http:/192.168.1.91:3000/create")!
                        let queryItems: [URLQueryItem] = [
                            .init(name: "number", value: text)
                        ]
                        components.queryItems = queryItems
                        return components.url!
                    }
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        
                        guard error == nil else {return}
                        confirmCodeScreen = true
                        
                    }
                    task.resume()
                    
                } label: {
                    Text("lets go")
                }
            }
            .navigationDestination(isPresented: $confirmCodeScreen) {
                ConfirmCode(text: $text)
            }
            
            
        }
        

            
        
    }
}

#Preview {
    OnboardingView()
}

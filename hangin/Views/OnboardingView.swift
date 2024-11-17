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
            
            ZStack {
                Color.background.ignoresSafeArea()
               
                VStack {
                    Spacer()
                    Image("hangin-logo-big")
                        .padding(.bottom, 30)
                    TextField("Enter your phone number", text: $text)
                        .padding(.vertical, 10)
                        
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.white)
                        .frame(width: 250)
                        .background(Color("textFieldBackground"))
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                    Button {
                        var url: URL {
                            var components = URLComponents(string: "\(Bundle.main.object(forInfoDictionaryKey: "BASE_URL") ?? "")/create")! // this needs to be handled in an error case
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
                            .fontWeight(.bold)
                            .foregroundStyle(Color("buttonText"))
                    }
                 
                    .padding(10)
                    .padding(.horizontal, 10)
                    .background(.circleBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.top, 3)
                    
                    Spacer()
                }
                .navigationDestination(isPresented: $confirmCodeScreen) {
                    ConfirmCode(text: $text)
                }
                
            }
           
            
            
        } 
        

            
        
    }
}

#Preview {
    OnboardingView()
}

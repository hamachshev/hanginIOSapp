//
//  ConfirmCode.swift
//  hangin
//
//  Created by Aharon Seidman on 9/20/24.
//

import SwiftUI
import KeychainSwift

struct ConfirmCode: View {
    @Binding var text: String
    @State private var confirmCode = ""
    @State private var showChatsScreen: Bool = false

    
    
    var body: some View {
        VStack {
            TextField("Enter code", text: $confirmCode)
            Button {
                var url: URL {
                    var components = URLComponents(string: "\(Bundle.main.object(forInfoDictionaryKey: "BASE_URL") ?? "")/oauth/token")! //handle all the error cases
                    let queryItems: [URLQueryItem] = [
                        .init(name: "client_id", value: Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as? String ?? "" ),
                        .init(name: "client_secret", value: Bundle.main.object(forInfoDictionaryKey: "CLIENT_SECRET") as? String ?? ""),
                        .init(name: "grant_type", value: "password"),
                        .init(name: "number", value: text),
                        .init(name: "code", value: confirmCode)
                    ]
                    components.queryItems = queryItems
                    return components.url!
                }
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    guard let data = data else { return }
                    if let user:User = try? decoder.decode(User.self, from: data) {
                        
                        if let accessToken = user.accessToken, let uuid = user.uuid, let createdAt = user.createdAt, let expiresIn = user.expiresIn, let refreshToken = user.refreshToken {
                            KeychainSwift().set(accessToken, forKey: "accessToken")
                            KeychainSwift().set(uuid, forKey: "uuid")
                            KeychainSwift().set("\(createdAt)", forKey: "createdAt")
                            KeychainSwift().set("\(expiresIn)", forKey: "expiresIn")
                            KeychainSwift().set(refreshToken, forKey: "refreshToken")
//                            if user.firstName == nil && user.lastName == nil{
//                                addNameScreen = true
//                            }
                            showChatsScreen = true
                            print(accessToken)
                            WebsocketManager.shared.startConnection()
                        }
                    }
                    
                    
                }
                task.resume()
                
            } label: {
                Text("send code")
            }
            
        }
        .navigationDestination(isPresented: $showChatsScreen) {
            MainScreen()
    }
        
}
}

#Preview {
    ConfirmCode(text: .constant("hello"))
}

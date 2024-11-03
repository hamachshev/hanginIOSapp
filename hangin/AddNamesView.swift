//
//  AddNamesView.swift
//  hangin
//
//  Created by Aharon Seidman on 9/20/24.
//

import SwiftUI
import KeychainSwift

struct AddNamesView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    
    var body: some View {
        VStack {
            Text("Add names")
            TextField("First Name", text: $firstName)
            TextField("Last Name", text: $lastName)
            Button("Add") {
                var url: URL {
                    var components = URLComponents(string: "http://192.168.1.86:3000/finalize")!
                    let queryItems: [URLQueryItem] = [
                        .init(name: "first_name", value: firstName),
                        .init(name: "last_name", value: lastName)
                    ]
                    components.queryItems = queryItems
                    
                    return components.url!
                }
                
                var request = URLRequest(url: url)
                let accessToken = KeychainSwift().get("accessToken")!

                request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                request.httpMethod = "POST"
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data else { return }
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let user = try? decoder.decode(User.self, from: data) {
//                        print("Welcome \(user.firstName! + user.lastName!)")
                    }
                    
                }
                task.resume()
            }
        }
        
    }
}

#Preview {
    AddNamesView()
}

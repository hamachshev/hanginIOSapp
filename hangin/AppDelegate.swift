//
//  AppDelegate.swift
//  hangin
//
//  Created by Aharon Seidman on 11/16/24.
//

import Foundation
import UIKit
import KeychainSwift

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        if KeychainSwift().getBool("NotificationsAllowed") == true {
            UIApplication.shared.registerForRemoteNotifications()
        }
        return true
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%.2hhx", $0) }.joined() // https://dev.to/mono/how-to-convert-an-apns-token-to-string-from-data-c8e
        sendToken(token: tokenString)
        print(tokenString)
    }
    
    func sendToken(token tokenString:String){
        let url = URL(string: "\(Bundle.main.object(forInfoDictionaryKey: "BASE_URL") ?? "")/user/registerIOSDevice")!
        
        //chat gpt generated for promt send tokne in req body
        let payload: [String: Any] = ["device_token": tokenString, "access_token": KeychainSwift().get("accessToken") ?? ""]
                                                                                                      
           guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
               print("Failed to serialize JSON")
               return
           }
           
           // Create a POST request
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           request.httpBody = jsonData
           
           // Send the request
           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               
               if let error = error {
                   print("Error sending device token: \(error)")
                   return
               }
               
               if let httpResponse = response as? HTTPURLResponse {
                   if httpResponse.statusCode == 401  && KeychainSwift().get("accessToken") != nil{
                       print("getting new token refresh")
                    
                       var url: URL {
                           var components = URLComponents(string: "\(Bundle.main.object(forInfoDictionaryKey: "BASE_URL") ?? "")/oauth/token")! //handle all the error cases
                           let queryItems: [URLQueryItem] = [
                               .init(name: "client_id", value: Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as? String ?? "" ),
                               .init(name: "client_secret", value: Bundle.main.object(forInfoDictionaryKey: "CLIENT_SECRET") as? String ?? ""),
                               .init(name: "grant_type", value: "refresh_token"),
                               .init(name: "refresh_token", value: "\(KeychainSwift().get("refreshToken") ?? "")")
                           ]
                           components.queryItems = queryItems
                           return components.url!
                       }
                       print(url)
                       var request = URLRequest(url: url)
                       request.httpMethod = "POST"
                       
                       let task = URLSession.shared.dataTask(with: request) { [weak self ] data, response, error in
                           guard let self = self else { return }
                           
                           let decoder = JSONDecoder()
                           decoder.keyDecodingStrategy = .convertFromSnakeCase
                           guard let data = data else { return }
                           print("pre acess token \(KeychainSwift().get("accessToken") ?? "")")
                           if let user:User = try? decoder.decode(User.self, from: data) {
                               
                               if let accessToken = user.accessToken, let createdAt = user.createdAt, let expiresIn = user.expiresIn, let refreshToken = user.refreshToken {
                                   KeychainSwift().set(accessToken, forKey: "accessToken")
                                   KeychainSwift().set("\(createdAt)", forKey: "createdAt")
                                   KeychainSwift().set("\(expiresIn)", forKey: "expiresIn")
                                   KeychainSwift().set(refreshToken, forKey: "refreshToken")
                                   
                                   print("post acess token\(accessToken)")
                                   sendToken(token: tokenString)
                               }
                           }
                       }
                       task.resume()
                   }
                       print(httpResponse.statusCode)
                   }
               print("Device token sent securely!")
           }
           task.resume()
    }
}

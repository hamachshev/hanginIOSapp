//
//  ChatsViewModel.swift
//  hangin
//
//  Created by Aharon Seidman on 10/29/24.
//

import Foundation
import KeychainSwift
import Starscream

@Observable
class ChatsViewModel {
    var chats: [Chat]?
    var socket: WebSocket?
    
    func startChatsWebsocket() {
        var req = URLRequest(url: URL(string: "wss://hangin-app-env.eba-hwfj6jrc.us-east-1.elasticbeanstalk.com/cable?access_token=" + (KeychainSwift().get("accessToken") ?? ""))!)
        req.timeoutInterval = 5
        socket = WebSocket(request: req)
        socket?.connect()
        
        socket?.onEvent = { [weak self] event in
            guard let self = self else {return}
            
            switch event {
            case .connected(_):
                print("connected to websocket")
                socket?.write(string: """
                              {
                                "command":"subscribe",
                                "identifier":"{\"channel\":\"ChatsChannel\"}"
                              }
                              """)
            case .disconnected(_, _): break
                
            case .text(let string):
                let decoder = JSONDecoder()
                let jsonData = string.data(using: .utf8)!
                
                if let message = try? decoder.decode(WebSocketMessage.self, from: jsonData){
                    
                    if message.type == "welcome"{
                        print("Welcome to the chat room!")
                    }
                    
                    if let messageData = message.message?.data(using: .utf8) {
                        
                        if let chats = try? decoder.decode(NewChatsMessage.self, from: messageData){
                            print("got chats -- multiple -- message")
                        }
                        
                        if let chat = try? decoder.decode(NewChatMessage.self, from: messageData){
                            print("got chat -- single -- message")
                        }
                    }
                }
                print("Received text: \(string)")
                
            case .binary(let data):
                print("Received data: \(data.count)")
                
            case .pong(_): break
                
            case .ping(_): break
                
            case .error(_): break
                
            case .viabilityChanged(_):break
                
            case .reconnectSuggested(_): break
                
            case .cancelled: break
                
            case .peerClosed: break
                
            }
        }
    }
}

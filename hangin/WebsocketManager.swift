//
//  WebsocketManager.swift
//  hangin
//
//  Created by Aharon Seidman on 10/28/24.
//

import Foundation
import Starscream
import KeychainSwift

@Observable
class WebsocketManager: WebSocketDelegate {
    static let shared = WebsocketManager()
    var chats: [Int] = []
    var chatMessages: [ChatMessageMessage] = []
    
    var currentChat: Int? {
        willSet{
            if let currentChat = currentChat {
                unsubscribe(chat: currentChat)
                chatMessages = []
            }
        }
        didSet {
            if let currentChat = currentChat {
                print("subbing to .....")
                subToChat(chat: currentChat)
            }
        }
    }
    
    private var socket: WebSocket?
    
    private init (){
    }
    
    func startConnection(){
        var req = URLRequest(url: URL(string: "\(Bundle.main.object(forInfoDictionaryKey: "WEB_SOCKET_URL") ?? "")?access_token=" + (KeychainSwift().get("accessToken") ?? ""))!)
        req.timeoutInterval = 5
        socket = WebSocket(request: req)
        socket?.connect()
        socket?.delegate = self
    }
    func newChat() {
        print("making new chat")
        socket?.write(string: """
                      {
                        "command":"message",
                        "identifier":"{\\"channel\\":\\"ChatsChannel\\"}",
                        "data":"{\\"action\\":\\"createChat\\"}"
                      }
                      """)
    }
    
    func subToChat(chat:Int){
        print("subbing to chat")
        
        socket?.write(string:"""
                                    {
                                        "command":"subscribe",
                                        "identifier":"{\\"channel\\":\\"ChatChannel\\", \\"id\\":\\"\(chat)\\"}"
                                      }
                """)
    }
    
    func unsubscribe(chat:Int){
        print("unsubbing to chat")
        
        socket?.write(string:"""
                                    {
                                        "command":"unsubscribe",
                                        "identifier":"{\\"channel\\":\\"ChatChannel\\", \\"id\\":\\"\(chat)\\"}"
                                      }
                """)
    }
    
    func sendMessage(message: String){
        print("sending message")
        
        socket?.write(string:"""
                                    {
                                        "command":"message",
                                        "identifier":"{\\"channel\\":\\"ChatChannel\\", \\"id\\":\\"\(currentChat!)\\"}",
                                        "data":"{\\"action\\":\\"speak\\",\\"body\\":\\"\(message)\\", \\"kind\\":\\"text\\", \\"status\\":\\"sent\\"}"
                                      }
                """)
    }
    
    func didReceive(event: WebSocketEvent, client: any WebSocketClient) {
            
            switch event {
            case .connected(_):
                print("connected to websocket")
                socket?.write(string: """
                              {
                                "command":"subscribe",
                                "identifier":"{\\"channel\\":\\"ChatsChannel\\"}"
                              }
                              """)
            case .disconnected(_, _): break
                
            case .text(let string):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let jsonData = string.data(using: .utf8)!
                
                if let message = try? decoder.decode(WebSocketMessage.self, from: jsonData){
                    
                    if message.type == "welcome"{
                        print("Welcome to the chat room!")
                    }
                }
                
                if let message = try? decoder.decode(NewChatsMessage.self, from: jsonData){
                    
                        chats  = message.message.chats
                        print("got new chats!!")

                }
                
                if let message = try? decoder.decode(OwnChatMessage.self, from: jsonData){
                    
                        currentChat = message.message.ownChat
                        print("got own chat")
      
                }
                if let message = try? decoder.decode(NewChatMessage.self, from: jsonData){
                    
                    chats.append(message.message.chat.id)
                        print("got own chat")
      
                }
                
                if let message = try? decoder.decode(ChatMessage.self, from: jsonData){
                    chatMessages.append(message.message.message)

                        print("got a message")
      
                }
                
                if let messagesMessgae = try? decoder.decode(MessagesMessage.self, from: jsonData){
                    for message in messagesMessgae.message.messages {
                        chatMessages.append(message)
                    }
                    
                        print("got a messages")
      
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

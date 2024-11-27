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
    var chats: [Chat] = []
    var chatMessages: [ChatMessageMessage] = []
    var contactsOnline: [ChatUser] = []
    var subbedToChatsChanel = false
    private var started = false
    
    var currentChat: Chat? {
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
        if started {return}
        
        var req = URLRequest(url: URL(string: "\(Bundle.main.object(forInfoDictionaryKey: "WEB_SOCKET_URL") ?? "")?access_token=" + (KeychainSwift().get("accessToken") ?? ""))!)
        req.timeoutInterval = 5
        socket = WebSocket(request: req)
        socket?.connect()
        socket?.delegate = self
        started = true
    }
    func newChat(name:String) {
        print("making new chat")
        socket?.write(string: """
                      {
                        "command":"message",
                        "identifier":"{\\"channel\\":\\"ChatsChannel\\"}",
                        "data":"{\\"action\\":\\"createChat\\",\\"name\\":\\"\(name)\\"}"
                      }
                      """)
    }
    
    func goToBackground() {
        print("going to the background")
        socket?.write(string: """
                      {
                        "command":"message",
                        "identifier":"{\\"channel\\":\\"ChatsChannel\\"}",
                        "data":"{\\"action\\":\\"go_to_background\\"}"
                      }
                      """)
        started = false
    
    }
    
    func subToChat(chat:Chat){
        print("subbing to chat")
        
        socket?.write(string:"""
                                    {
                                        "command":"subscribe",
                                        "identifier":"{\\"channel\\":\\"ChatChannel\\", \\"id\\":\\"\(chat.id )\\"}"
                                      }
                """)
    }
    
    func unsubscribe(chat:Chat){
        print("unsubbing to chat")
        
        socket?.write(string:"""
                                    {
                                        "command":"unsubscribe",
                                        "identifier":"{\\"channel\\":\\"ChatChannel\\", \\"id\\":\\"\(chat.id)\\"}"
                                      }
                """)
    }
    
    func sendMessage(message: String){
        print("sending message")
        
        //handle error case
        socket?.write(string:"""
                                    {
                                        "command":"message",
                                        "identifier":"{\\"channel\\":\\"ChatChannel\\", \\"id\\":\\"\(currentChat!.id )\\"}",
                                        "data":"{\\"action\\":\\"speak\\",\\"body\\":\\"\(message)\\", \\"kind\\":\\"text\\", \\"status\\":\\"sent\\"}"
                                      }
                """)
    }
    
    func subToChatsChannel(){
        print("hi")
        socket?.write(string: """
                      {
                        "command":"subscribe",
                        "identifier":"{\\"channel\\":\\"ChatsChannel\\"}"
                      }
                      """)
        subbedToChatsChanel = true
    }
    
    func didReceive(event: WebSocketEvent, client: any WebSocketClient) {
            
            switch event {
            case .connected(_):
                print("connected to websocket")
                subToChatsChannel()
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
                
                if let message = try? decoder.decode(UnauthorizedMessage.self, from: jsonData){
                    if(message.type == "disconnect" && message.reason == "unauthorized"){
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
                                    var req = URLRequest(url: URL(string: "\(Bundle.main.object(forInfoDictionaryKey: "WEB_SOCKET_URL") ?? "")?access_token=" + accessToken)!)
                                    req.timeoutInterval = 5
                                    socket = WebSocket(request: req)
                                    socket?.connect()
                                    socket?.delegate = self
                                }
                            }
                        }
                        task.resume()
                    }
                }
                
                if let message = try? decoder.decode(NewChatsMessage.self, from: jsonData){
                    
                        chats  = message.message.chats
                        print("got new chats!!")

                }
                
                if let message = try? decoder.decode(OwnChatMessage.self, from: jsonData){
                    
                        currentChat = message.message.ownChat
                        chats.append(message.message.ownChat)
                        print("got own chat")
      
                }
                if let message = try? decoder.decode(NewChatMessage.self, from: jsonData){
                    
                        chats.append(message.message.chat)
                        print("got new chat")
      
                }
                
                if let message = try? decoder.decode(DeleteChatMessage.self, from: jsonData){
                    
                    chats = chats.filter { chat in
                        chat.id != message.message.deleteChat
                    }
                        print("deleting chat")
      
                }
                if let message = try? decoder.decode(UpdateChatMessage.self, from: jsonData){
                    
                    chats = chats.map { chat in
                        if chat.id == message.message.updateChat.id {
                            return message.message.updateChat
                        } else {
                            return chat
                        }
                    }
                        print("updating chat")
      
                }
                
                if let message = try? decoder.decode(ContactOnlineMessage.self, from: jsonData){
                    
                       contactsOnline.append(message.message.contactOnline)
                        print("new online user!!")
      
                }
                
                if let message = try? decoder.decode(ContactsOnlineMessage.self, from: jsonData){
                    
                        contactsOnline = message.message.contactsOnline
                        print("new online users!!")
      
                }
                
                if let message = try? decoder.decode(ContactOfflineMessage.self, from: jsonData){
                    
                    contactsOnline = contactsOnline.filter { contact in
                        contact.uuid != message.message.contactOffline
                    }
                        print("new online user!!")
      
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

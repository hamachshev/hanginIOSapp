//
//  MainScreen.swift
//  hangin
//
//  Created by Aharon Seidman on 10/27/24.
//

import SwiftUI
import Starscream
import KeychainSwift

struct MainScreen: View {
    
    @State var enterChatName = false
    @State var chatName: String = ""
    @FocusState private var fieldFocused: Bool
    @State var webSocketManager = WebsocketManager.shared
    @State var showOnlineUsers: Bool = false
    @Binding var path: NavigationPath
    var body: some View {
        
        ScrollView {
            VStack(spacing: 15){
               
                VStack(spacing: 0){
                HStack {
                    Text("Chats")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundStyle(.white)
                    Spacer()
                    Circles2(users: webSocketManager.contactsOnline)
                        .onTapGesture {
                            showOnlineUsers.toggle()
                        }
                }
                    if showOnlineUsers {
                        ParticipantsView(users: webSocketManager.contactsOnline, inviteToChatOnTap: true)
                            .padding(.top, 5)
                    }
                }.animation(.bouncy, value: showOnlineUsers)
                .padding(.vertical, 20)
                .padding(.horizontal, 10)
            
                
                Button(action:{
                    
                    enterChatName = true
                    fieldFocused = true
                }){
                    if !enterChatName {
                        Text("Make new chat")
                            .fontWeight(.heavy)
                    } else {
                        TextField("Enter chat name", text: $chatName)
                            .focused($fieldFocused)
                            .onSubmit {
                                webSocketManager.newChat(name: chatName)
                                
//                                chatScreenPresented = true
                                path.append("messageBox")
                                print(chatName)
                                enterChatName = false
                                chatName = ""
                            }
                    }
                }
                .padding(20)
                .font(.title3)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(RoundedRectangle(cornerRadius: 25).fill(Color("secondary")))
                
               
                
                ForEach(webSocketManager.chats, id:\.self){ chat in
                    ChatBar(chat: chat, action: { 
                        path.append("messageBox")
                        webSocketManager.currentChat = chat
                    })
                    
              
                    
                }
                
                
            }
            .animation(.easeInOut, value: showOnlineUsers)
        }
        .onAppear{
            webSocketManager.startConnection()
        }
        .toolbar(.hidden)
//        
//        .navigationDestination(isPresented: $chatScreenPresented, destination:{
//            MessageBoxView()
//        })
        
        .ignoresSafeArea(edges: .all)
        
        .padding(15)
        .listStyle(.plain)
        .background(Color("background"))
        .scrollContentBackground(.hidden)
            
            
            
            
        }
        
        
        
        
    }

#Preview {
    MainScreen(path: .constant(NavigationPath()))
}

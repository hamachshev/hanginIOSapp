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
    
    @State var chatScreenPresented = false

    @State var webSocketManager = WebsocketManager.shared
    
    var body: some View {
        
        ScrollView{
            
            Button(action:{
                webSocketManager.newChat()
                
                chatScreenPresented = true
            }){
                        Text("newChat")
                    }
                    .padding(20)
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(RoundedRectangle(cornerRadius: 25).fill(Color("secondary")))
            
            ForEach(webSocketManager.chats, id:\.self){ chat in
                
                Button(action:{
                    chatScreenPresented = true
                    webSocketManager.currentChat = chat
                }){
                        Text("\(chat)")
                    }
                    .padding(20)
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(RoundedRectangle(cornerRadius: 25).fill(Color("secondary")))
            }
                    
                
        }.onAppear{
            webSocketManager.startConnection()
        }
            .navigationTitle("Chats")
            
            .navigationDestination(isPresented: $chatScreenPresented, destination:{
                MessageBoxView()
            })
            
            .ignoresSafeArea(edges: .all)
            
            .padding(20)
            .listStyle(.plain)
            .background(Color.red)
            .scrollContentBackground(.hidden)
            
            
            
            
        }
        
        
        
        
    }

#Preview {
    MainScreen()
}

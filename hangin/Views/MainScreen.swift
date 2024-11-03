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
    @State var messageText = ""
    @State var chatScreenPresented = false
    @FocusState var intputMessageBoxFocus:Bool
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
            
            ForEach(webSocketManager.chats ?? [], id:\.self){ chat in
                
                    Button(action:{chatScreenPresented = true}){
                        Text("Chat 1")
                    }
                    .padding(20)
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(RoundedRectangle(cornerRadius: 25).fill(Color("secondary")))
            }
                    
                
            }
            .navigationTitle("Chats")
            
            .navigationDestination(isPresented: $chatScreenPresented, destination:{
                VStack {
                    
                    HStack{
                        Image("hangin-logo-big")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120)
                        Spacer()
                        Circle()
                            .fill(Color("secondary"))
                            .frame(width: 35)
                    }
                    Spacer()
                    ScrollView {
                        Spacer()
                        HStack{
                            
                            Text("TestMEssage")
                                .foregroundColor(.white)
                                .font(.caption)
                                .padding(10)
                                .padding(.horizontal, 10)
                                .background(RoundedRectangle(cornerRadius: 25)
                                    .fill(Color("secondary")))
                            Spacer()
                        }
                        .padding(.bottom, 5)
                        HStack{
                            Spacer()
                            Text("TestMEssage")
                                .foregroundColor(.white)
                                .font(.caption)
                                .padding(10)
                                .padding(.horizontal, 10)
                                .background(RoundedRectangle(cornerRadius: 25)
                                    .fill(Color("ownMessage")))
                        }
                        .padding(.bottom, 5)
                    }
                    .defaultScrollAnchor(.bottom) // https://www.hackingwithswift.com/quick-start/swiftui/how-to-make-a-scrollview-start-at-the-bottom#:~:text=SwiftUI's%20ScrollView%20starts%20scrolling%20from,bottom%20.
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture {
                        intputMessageBoxFocus = false
                    }
                    
                    
                    HStack {
                        TextField(text: $messageText, prompt: Text("Say something")
                            .foregroundColor(.white)
                            .font(.caption))
                        {}.focused($intputMessageBoxFocus)
                            .padding(.leading, 20)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color("secondary"))
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                        
                            .padding(.trailing, 10)
                        Image(systemName: "arrow.up")
                            .font(.title3)
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color("secondary")))
                    }
                    .padding(.top, 10)
                    
                    
                    
                    
                    
                }
                
                .padding(30)
                .padding(.horizontal, 10)
                .background(Color("background").edgesIgnoringSafeArea(.all))
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

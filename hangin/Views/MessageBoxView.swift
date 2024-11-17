//
//  MessageBoxView.swift
//  hangin
//
//  Created by Aharon Seidman on 10/29/24.
//

import SwiftUI
import KeychainSwift

struct MessageBoxView: View {
    @State var messageText = ""
    @FocusState var intputMessageBoxFocus:Bool
    @State var webSocketManager = WebsocketManager.shared
    @State var showParticipants:Bool = false
    
    var body: some View {
        VStack {
            
            VStack {
                HStack{
                    Text(webSocketManager.currentChat?.name ?? "")
                        .font(.title)
                        .fontWeight(.heavy)
                    Spacer()
                    Circles2(users: webSocketManager.currentChat?.users ?? [])
                        .onTapGesture {
                            showParticipants.toggle()
                        }
                    
                }
                if showParticipants {
                    ParticipantsView(users: webSocketManager.currentChat?.users ?? [])
                }
            }
            Spacer()
            ScrollView {
                Spacer()
                
                ForEach(webSocketManager.chatMessages, id: \.self){message in
                    if message.userUuid == KeychainSwift().get("uuid") {
                        RightMessage(text: message.body)
                    } else {
                        LeftMessage(text: message.body)
                    }
                }
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
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color("secondary"))
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                
                    .padding(.trailing, 10)
                Button(action: {
                    webSocketManager.sendMessage(message: messageText)
                    messageText = ""
                }){
                    Image(systemName: "arrow.up")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color("secondary")))
                }
            }
            .padding(.top, 10)
            
            
            
            
            
        }
        
        .padding(15)
        .padding(.horizontal, 10)
        .background(Color("background").edgesIgnoringSafeArea(.all))
//        .toolbar(.hidden)
        
    }
}

#Preview {
    MessageBoxView()
}

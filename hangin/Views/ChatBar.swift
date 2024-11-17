//
//  ChatBar.swift
//  hangin
//
//  Created by Aharon Seidman on 11/14/24.
//

import SwiftUI

struct ChatBar: View {
    @State var openParticipants = false
    var chat: Chat
    var action: ()->Void
    
    var body: some View {
        VStack(spacing: 10) {
            HStack{
                Circles2(users: chat.users)
                    .onTapGesture {
                       
                            openParticipants.toggle()
                        
                    }
                Text(chat.name)
                    .padding(.horizontal, 10)
                    .fontWeight(.heavy)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            
            if openParticipants{
                
                ParticipantsView(users: chat.users)
//                    .animation(.bouncy, value: openParticipants)
            }
            
          
        }
            .padding(15)
            .font(.title3)
            .foregroundStyle(.white)
            .animation(openParticipants ? .easeInOut.delay(0.2) : .easeInOut.speed(2), value: openParticipants)
            .background(
                RoundedRectangle(cornerRadius: 25).fill(Color("secondary"))
                    .animation(.easeInOut, value: openParticipants)
                    .onTapGesture {
                        action()
                    }
            )
        
    }
}

#Preview {
    ChatBar(chat: Chat(id: 1, name: "hello", users: []), action: {print("tapped")})
}


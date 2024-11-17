//
//  ParticipantsView.swift
//  hangin
//
//  Created by Aharon Seidman on 11/14/24.
//

import SwiftUI

struct ParticipantsView: View {
     var users: [ChatUser]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(users, id: \.self){ user in
                    HStack {
                        HStack(spacing: 10) {
                            ZStack {
                                // Shadow circle layer
                                Circle()
                                    .fill(Color.black.opacity(0.2))  // Shadow color
                                    .frame(width: 30)
                                    .offset(x: -5, y: 4)  // Offset for shadow positioning
                                    .blur(radius: 4)      // Blurring to soften the shadow
                                
                                // Main circle layer
                                Circle()
                                    .fill(Color("CircleBackground"))
                                    .frame(width: 30)
                                if let urlString  = user.profilePic {
                                    AsyncImage(url: URL(string: urlString)){
                                        image in
                                        image.resizable()
                                    } placeholder: {
                                        
                                    }
                                    .frame(width:30, height: 30)
                                    .clipShape(.circle)
                                }
                                
                            }.padding(.vertical, 10)
                            
                        }
                        
                        Text("\(user.firstName) \(user.lastName)")
                            .font(.caption)
                            .foregroundStyle(.white)
                            .fontWeight(.regular)
                        
                    }
                    .padding(.horizontal, 13)
                    .background(
                        
                        RoundedRectangle(cornerRadius: 38)
                            .fill(Color("CircleBackground"))
                            .frame(minHeight: 45, maxHeight: 45)
                    )
                    
                }
                .padding(.vertical, 10) // not sure why need this, but otherwize clips
            }
            }
        }
    }



#Preview {
    ParticipantsView(users:[ChatUser(uuid: "8", firstName: "kjfdhsa", lastName: "fjhdsk", number: "98877776666", profilePic: "https://picsum.photos/200/300"), ChatUser(uuid: "8", firstName: "kjfdhsa", lastName: "fjhdsk", number: "98877776666", profilePic: "https://picsum.photos/200/300")])
}

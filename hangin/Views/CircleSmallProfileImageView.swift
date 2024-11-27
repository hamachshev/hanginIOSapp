//
//  CircleSmallProfileImageView.swift
//  hangin
//
//  Created by Aharon Seidman on 11/16/24.
//

import SwiftUI

struct CircleSmallProfileImageView: View {
    var user:ChatUser
    var body: some View {
        ZStack {
            // chat gpt generated the circles
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
}

#Preview {
    CircleSmallProfileImageView(user: ChatUser(uuid: "sd", firstName: "s", lastName: "Fds", number: "fds"))
}

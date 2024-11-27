//
//  ParticipantsView.swift
//  hangin
//
//  Created by Aharon Seidman on 11/14/24.
//

import SwiftUI

struct ParticipantsView: View {
     var users: [ChatUser]
    var inviteToChatOnTap: Bool = false

    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10){
                ForEach(users, id: \.self){ user in
                    ParticipantView(user: user, inviteToChatOnTap: inviteToChatOnTap)
                    
                }
                .padding(.vertical, 10) // not sure why need this, but otherwize clips
            }
            }
            
        }

    }



#Preview {
    ParticipantsView(users:[ChatUser(uuid: "8", firstName: "kjfdhsa", lastName: "fjhdsk", number: "98877776666", profilePic: "https://picsum.photos/200/300"), ChatUser(uuid: "8", firstName: "kjfdhsa", lastName: "fjhdsk", number: "98877776666", profilePic: "https://picsum.photos/200/300")], inviteToChatOnTap: false)
}

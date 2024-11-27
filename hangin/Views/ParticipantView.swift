//
//  ParticipantView.swift
//  hangin
//
//  Created by Aharon Seidman on 11/16/24.
//

import SwiftUI

struct ParticipantView: View {
    var user: ChatUser
    var inviteToChatOnTap: Bool
    @State var showConfirmationAlert: Bool  = false
    @State var selectedUser: ChatUser?
    var body: some View {
        HStack {
            
            CircleSmallProfileImageView(user: user)
            
            
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
        .onTapGesture {
            selectedUser = user
            if inviteToChatOnTap {
                showConfirmationAlert = true
            }
        }
        .alert("Invite \(selectedUser?.firstName ?? "") \(selectedUser?.lastName ?? "" )", isPresented: $showConfirmationAlert){
            Button("Lets go!"){
                inviteToChat(selectedUser)
            }
            Button("Cancel", role: .cancel){}
        } message: {
            Text("Invite \(selectedUser?.firstName ?? "") \(selectedUser?.lastName ?? "" ) to live chat with you!")
        }
        
    }
    
    private func inviteToChat(_ user:ChatUser?){
        guard let user = user else { return }
        
        
    }
}

#Preview {
    ParticipantView(user: ChatUser(uuid: "sd", firstName: "s", lastName: "Fds", number: "fds"), inviteToChatOnTap: true)
}

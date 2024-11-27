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
    @State var showInviteFriendsSheet:Bool = false
    @State var mode:EditMode = .active
    
    @State var selectedUsers = Set<ChatUser>()

    @State var users: [ChatUser] = []
    
    var body: some View {
        VStack {
            
            VStack {
                HStack{
                    Text(webSocketManager.currentChat?.name ?? "")
                        .font(.title)
                        .fontWeight(.heavy)
                    Spacer()

                        
                        
                        Circles2(users: users)
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
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Button(action:{
                    mode = .active
                    showInviteFriendsSheet = true
                    
                }){
                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
            }
        }
        .sheet(isPresented: $showInviteFriendsSheet) {
            
            NavigationStack {
                List(users, id: \.self, selection: $selectedUsers){ user in
                    Text("\(user.firstName) \(user.lastName)")
                }
                .toolbar(content: {
                EditButton()
            })
                .navigationTitle("Invite contacts")
                .environment(\.editMode, $mode)
            }
            
            .onAppear{
                mode = .active
            }
            .onChange(of: mode, initial: false) { _, newValue in
                //send the data to the server
                if mode.isEditing == false {
                    inviteToChat()
                }
                
            }
            .onAppear {
                Task.detached {
                    await fetchContacts()
                }
            }
        
        
        }
        
    }
    func fetchContacts(){
        var url: URL {
            var components = URLComponents(string: "\(Bundle.main.object(forInfoDictionaryKey: "BASE_URL") ?? "")/friends")! //handle all the error cases
            let queryItems: [URLQueryItem] = [
                .init(name: "access_token", value: KeychainSwift().get("accessToken") ??  "") //change this to Keychain Later
            ]
            components.queryItems = queryItems
            return components.url!
        }
        print(url)
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let error {
                    print(error.localizedDescription)
                } else if let data {
                    print(data)
                    
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let contactsAndFriends = try? decoder.decode(ContactsFriendsResponse.self, from: data){
                        users = contactsAndFriends.contacts
                        
                    }
                    }
                
            }
        task.resume()
            
    }
    
    func inviteToChat(){
       
        let url = URL(string:"\(Bundle.main.object(forInfoDictionaryKey: "BASE_URL") ?? "")/notifications/invite")!
        
        var request = URLRequest(url: url)
        
        let jsonBody: [String: Any] = [
            "access_token": KeychainSwift().get("accessToken") ??  "",
            "chatId": webSocketManager.currentChat?.id ?? "",
            "users_to_invite": Array(selectedUsers).map({ user in
                user.uuid
            })
        ]
        
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //chat gpt for the do catch
            do {
                   request.httpBody = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
               } catch {
                   print("Error encoding JSON: \(error)")
                   return
               }
        
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let error {
                    print(error.localizedDescription)
                } else if let data {
                    print(data)
                    
                    }
                
                if let httpResponse = response as? HTTPURLResponse { // https://stackoverflow.com/questions/40382505/how-do-you-test-a-url-and-get-a-status-code-in-swift-3
                    
                    if httpResponse.statusCode == 204 {
                        showInviteFriendsSheet = false
                        
                    }
                }
                
            }
        task.resume()
            
    }
}

#Preview {
    MessageBoxView()

}

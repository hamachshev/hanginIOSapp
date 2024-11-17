//
//  SelectContactsView.swift
//  hangin
//
//  Created by Aharon Seidman on 11/9/24.
//

import SwiftUI
import Contacts

struct SelectContactsView: View {
    @State var mode:EditMode = .active
    @State var selectedContacts = Set<CNContact>()
    @State var showContacts: Bool = false
    @Binding var contacts: [CNContact]
    
    var body: some View {
        VStack{
            List(contacts, id: \.self, selection: $selectedContacts){ contact in
                Text("\(contact.givenName) \(contact.familyName)")
            }
        }.toolbar(content: {
            EditButton()
        })
        
        .environment(\.editMode, $mode)
        .onChange(of: mode, initial: false) { _, newValue in
            //send the data to the server
            if mode.isEditing == false {
                var url: URL {
                    var components = URLComponents(string: "\(Bundle.main.object(forInfoDictionaryKey: "BASE_URL") ?? "")/friends")! //handle all the error cases
                    let queryItems: [URLQueryItem] = [
                        .init(name: "access_token", value: "hIo9suYXaSyhf37gowdOeq8Q7LaUHocSo0luAsWEq5Q") //change this to Keychain Later
                    ]
                    components.queryItems = queryItems
                    return components.url!
                }
                
                var request = URLRequest(url: url)
                
                var friends = Friends()
                
                for contact in selectedContacts {
                    let friend = Friend(firstName: contact.givenName, lastName: contact.familyName, number: contact.phoneNumbers[0].value.stringValue)
                    friends.friends.append(friend)
                }
                let encoder = JSONEncoder()
                
                encoder.keyEncodingStrategy = .convertToSnakeCase
                
                request.httpMethod = "POST"
                
                let jsonData = try? encoder.encode(friends) //handle error
                
                if let jsonString = String(data: jsonData!, encoding: .utf8) {
                        print(jsonString)  // Prints the JSON as a string
                    } else {
                        print("Failed to convert Data to String.")
                    }
                
                guard let jsonData else { return }
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData as Data
                
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        
                        if let error {
                            print(error.localizedDescription)
                        } else if let data {
                            print(data)
                            
                                let decoder = JSONDecoder()
                                decoder.keyDecodingStrategy = .convertFromSnakeCase
                                let friends = try? decoder.decode([Friend].self, from: data)
                                
                            print(friends ?? "")
                            }
                        
                        if let httpResponse = response as? HTTPURLResponse { // https://stackoverflow.com/questions/40382505/how-do-you-test-a-url-and-get-a-status-code-in-swift-3
                            
                            if httpResponse.statusCode == 201 {
                                showContacts = true
                            }
                        }
                        
                    }
                task.resume()
                    
            }
            
        }
        .onAppear{
            Task.detached {
                await fetchContacts()
            }
        }
        .navigationDestination(isPresented: $showContacts) {
            MainScreen()
        }
    }
    
    private func fetchContacts() async {
        let store = CNContactStore()
        
        switch CNContactStore.authorizationStatus(for: .contacts){
        case .notDetermined:
            do{
                let response = try await store.requestAccess(for: .contacts)
                if response == true{
                    await fetchContacts()
                }
                
                
            } catch {
                print(error.localizedDescription)
            }
            
        case .restricted: break
            
        case .denied: break
            
        case .authorized:
            let req = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor])
            var contactArray = [CNContact]()
            try! store.enumerateContacts(with: req) { contact, _ in
                contactArray.append(contact)
            }
            await MainActor.run {
                contacts = contactArray
            }
        case .limited: break
            
        @unknown default: break
            
        }
    }
}

//#Preview {
//    SelectContactsView(contacts: )
//}

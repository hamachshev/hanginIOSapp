//
//  ContactsImport.swift
//  hangin
//
//  Created by Aharon Seidman on 11/7/24.
//

import SwiftUI
import Contacts
import KeychainSwift

struct ContactsImport: View {
    
    @State var showContacrtPicker: Bool = false
    @State var contacts: [CNContact] = []

    var body: some View {
        
        NavigationStack {
            Button("Import Contacts") {
                showContacrtPicker = true
            }
            .navigationDestination(isPresented: $showContacrtPicker){
                SelectContactsView(contacts: $contacts)
            }
        }
        
    }
    
   
    
}

#Preview {
    ContactsImport()
}

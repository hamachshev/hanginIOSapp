//
//  ContactPicker.swift
//  hangin
//
//  Created by Aharon Seidman on 11/7/24.
//

import Foundation
import SwiftUI
import ContactsUI

struct ContactPicker: UIViewControllerRepresentable {
    @Binding var contacts: [CNContact]
    typealias UIViewControllerType = CNContactPickerViewController
    
    class Coordinator: NSObject, CNContactPickerDelegate {
        let parent: ContactPicker
        
        init(_ parent: ContactPicker) {
            self.parent = parent
        }
        
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            parent.contacts[0] = contact
            picker.dismiss(animated: true)
            
        }
        
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
            parent.contacts = contacts
            picker.dismiss(animated: true)
        }
        
        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
            picker.dismiss(animated: true)
        }
    }
    
    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let uiViewController = CNContactPickerViewController()
        uiViewController.delegate = context.coordinator
        return uiViewController
    }
    
    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    

    

    
    
}

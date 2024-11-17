//
//  ContactsOnlineMessage.swift
//  hangin
//
//  Created by Aharon Seidman on 11/15/24.
//

import Foundation

struct ContactsOnlineMessage: Codable {
    var message: ContactsOnlineBody
}

struct ContactsOnlineBody: Codable {
    var contactsOnline : [ChatUser]
}

//
//  ContactOnlineMessage.swift
//  hangin
//
//  Created by Aharon Seidman on 11/15/24.
//

import Foundation

struct ContactOnlineMessage: Codable {
    var message: ContactOnlineBody
}

struct ContactOnlineBody: Codable {
    var contactOnline : ChatUser
}

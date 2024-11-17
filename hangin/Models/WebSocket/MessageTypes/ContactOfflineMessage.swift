//
//  ContactOfflineMessage.swift
//  hangin
//
//  Created by Aharon Seidman on 11/15/24.
//

import Foundation

struct ContactOfflineMessage: Codable {
    var message: ContactOfflineBody
}

struct ContactOfflineBody: Codable {
    var contactOffline: String
}

//
//  OwnChatMessage.swift
//  hangin
//
//  Created by Aharon Seidman on 10/29/24.
//

import Foundation

struct OwnChatMessage: Codable {
    var message: OwnChat
}


struct OwnChat: Codable {
    var ownChat:Chat
}



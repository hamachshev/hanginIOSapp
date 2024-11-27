//
//  UpdateChatMessage.swift
//  hangin
//
//  Created by Aharon Seidman on 11/17/24.
//

import Foundation

struct UpdateChatMessage: Codable {
    var message: UpdateChatBody
}

struct UpdateChatBody: Codable {
    var updateChat: Chat
}

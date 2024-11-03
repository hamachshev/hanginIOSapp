//
//  NewChatsMessage.swift
//  hangin
//
//  Created by Aharon Seidman on 10/29/24.
//

import Foundation

struct NewChatsMessage: Codable {
    var message: Chats
}

struct Chats: Codable {
    var chats: [Int]
}

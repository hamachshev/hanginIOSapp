//
//  NewChatMessage.swift
//  hangin
//
//  Created by Aharon Seidman on 10/29/24.
//

import Foundation

struct NewChatMessage: Codable {
    var message: NewChatMessageMessage
}

struct NewChatMessageMessage: Codable {
    var chat: idStruct
}

struct idStruct: Codable {
    var id: Int
}

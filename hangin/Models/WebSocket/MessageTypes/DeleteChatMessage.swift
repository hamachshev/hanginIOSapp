//
//  DeleteChatMessage.swift
//  hangin
//
//  Created by Aharon Seidman on 10/29/24.
//

import Foundation

struct DeleteChatMessage: Codable {
    var message: DeleteChatMessageMessage
}

struct DeleteChatMessageMessage: Codable {
    var deleteChat: Int
}

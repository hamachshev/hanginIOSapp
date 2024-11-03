//
//  ChatMessage.swift
//  hangin
//
//  Created by Aharon Seidman on 10/29/24.
//

import Foundation

// {"identifier":"{\"channel\":\"ChatChannel\", \"id\":\"271\"}","message":{"message":{"user_uuid":"91e7744b-35f5-4384-849a-2aa0e26301ee","kind":"text","first_name":"Aharon","last_name":"Seidman","body":"Hello again"}}}

struct ChatMessage: Codable {
    var message: intermMessage
}

struct intermMessage: Codable {
    var message: ChatMessageMessage
}

struct ChatMessageMessage: Codable, Hashable {
    var userUuid: String
    var kind: String
    var firstName: String
    var lastName: String
    var body: String
}

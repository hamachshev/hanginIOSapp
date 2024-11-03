//
//  Messages.swift
//  hangin
//
//  Created by Aharon Seidman on 11/3/24.
//

import Foundation

//{"identifier":"{\"channel\":\"ChatChannel\", \"id\":\"301\"}","message":{"messages":[{"user_uuid":"91e7744b-35f5-4384-849a-2aa0e26301ee","kind":"text","first_name":"Aharon","last_name":"Seidman","body":"Hey"}]}}

struct MessagesMessage: Codable {
    var message: Messages
}

struct Messages:Codable {
    var messages: [ChatMessageMessage]
}

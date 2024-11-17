//
//  Chat.swift
//  hangin
//
//  Created by Aharon Seidman on 10/29/24.
//

import Foundation

struct Chat : Codable, Hashable{
    var id: Int
    var name: String
    var users: [ChatUser]
}

struct ChatUser: Codable, Hashable{
    var uuid: String
    var firstName: String
    var lastName: String
    var number: String
    var profilePic: String?
}

//
//  contactsFriendsResponse.swift
//  hangin
//
//  Created by Aharon Seidman on 11/16/24.
//

import Foundation

struct ContactsFriendsResponse: Codable {
    let friends: [Friend]
    let contacts: [ChatUser]
}

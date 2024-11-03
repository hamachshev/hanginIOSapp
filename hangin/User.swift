//
//  User.swift
//  hangin
//
//  Created by Aharon Seidman on 9/19/24.
//

import Foundation

struct User: Codable {
    var accessToken:String?
    var uuid:String?
    var createdAt:Int?
    var expiresIn:Int?
    var refreshToken: String?
        
}

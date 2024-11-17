//
//  Friend.swift
//  hangin
//
//  Created by Aharon Seidman on 11/9/24.
//

import Foundation

struct Friend: Codable {
    var firstName: String
    var lastName: String
    var number: String
    
}


struct Friends : Codable {
    var friends = [Friend]()
}

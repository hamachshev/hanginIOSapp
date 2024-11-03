//
//  UnauthorizedMessage.swift
//  hangin
//
//  Created by Aharon Seidman on 11/3/24.
//

import Foundation

// {"type":"disconnect","reason":"unauthorized","reconnect":false}
struct UnauthorizedMessage: Codable {
    var type: String
    var reason: String
}

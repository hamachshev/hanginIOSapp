//
//  WebSocketResponse.swift
//  hangin
//
//  Created by Aharon Seidman on 10/29/24.
//

import Foundation

struct WebSocketMessage: Codable {
    var type: String?
    var message: String?
}

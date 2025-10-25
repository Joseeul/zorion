//
//  UserModel.swift
//  zorion
//
//  Created by Jose Andreas on 24/10/25.
//

import Foundation

// untuk register user kedalam database
struct InsertUser: Codable {
    let username: String
    let content_creator: Bool
}

//
//  RoomModel.swift
//  zorion
//
//  Created by Jose Andreas on 25/10/25.
//

import Foundation

// untuk register room kedalam database
struct InsertRoom: Codable {
    let room_owner: UUID
    let room_name: String
    let room_desc: String
}

struct RoomData: Codable {
    let room_id: UUID
    let room_owner: UUID
    let room_name: String
    let room_desc: String
    let room_picture: String?
}

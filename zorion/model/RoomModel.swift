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

// untuk upload picture ke storage
struct RoomData: Codable {
    let room_id: UUID
    let room_owner: UUID
    let room_name: String
    let room_desc: String
    let room_picture: String?
    let created_at: Date?
}

// untuk fetch room creator
struct RoomModel: Codable {
    let room_id: UUID
    let room_owner: UUID
    let room_name: String
    let room_desc: String
    let room_picture: String
    let created_at: Date
}

// untuk fetch room member
struct RoomMember: Codable {
    let id: Int
    let created_at: Date
    let user_id: UUID
    let room_id: UUID
}

// untuk insert room member
struct InsertRoomMember: Codable {
    let user_id: UUID
    let room_id: UUID
}

// untuk response community room user yang sudah join
struct CommunityRoomUser: Codable {
    let id: Int
    let user_id: UUID
    let room_id: UUID
    let created_at: Date
    let room: RoomModel
}

// untuk response fetch semua room member
struct AllRoomMember: Codable {
    let id: Int
    let created_at: Date
    let user_id: UUID
    let room_id: UUID
    let user: UserModel
}

// untuk insert message
struct InsertMessage: Codable {
    let user_id: UUID
    let room_id: UUID
    let message_image: String?
    let message: String
}

// model untuk message
struct MessageModel: Codable {
    let id: Int
    let created_at: Date
    let user_id: UUID
    let room_id: UUID
    let message_image: String?
    let message: String
    let user: UserModel
    let room: RoomModel
}

// model untuk vote choice/option (struct internal)
struct VoteOption: Identifiable {
    var id = UUID()
    var text: String = ""
}

// model untuk insert vote
struct InsertVoteModel: Codable {
    let room_id: UUID
    let question: String
}

// model untuk insert choice
struct InsertChoiceModel: Codable {
    let vote_id: UUID
    let choice: String
}

// model untuk fetch data vote
struct VoteModel: Codable, Identifiable {
    var id: UUID { vote_id }
    
    let vote_id: UUID
    let created_at: Date
    let room_id: UUID
    let question: String
    let vote_choices: [VoteChoiceModel]
}

// model untuk join vote dan choice
struct VoteChoiceModel: Codable, Identifiable {
    var id: UUID { choice_id }
    
    let choice_id: UUID
    let created_at: Date
    let vote_id: UUID
    let choice: String
}

// untuk ambil vote_id
struct InsertResponse: Codable {
    let vote_id: UUID
}

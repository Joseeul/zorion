//
//  roomController.swift
//  zorion
//
//  Created by Jose Andreas on 24/10/25.
//

import Foundation
import Supabase
import UIKit

private let client = SupabaseManager.shared.client

// add room kedalam tabel room
func addRoomData(roomName: String, roomDesc: String) async throws {
    let roomOwner = try await client.auth.user().id
    let room = InsertRoom(room_owner: roomOwner, room_name: roomName, room_desc: roomDesc)
    
    try await client
        .from("room")
        .insert(room)
        .execute()
}

// upload room picture user kedalam bucket
func uploadRoomPicture() async throws {
    let roomPicture: String = UserDefaults.standard.string(forKey: "userRoomPicture")!
    let userId: String = UserDefaults.standard.string(forKey: "userId")!
    
    let roomData: [RoomData] = try await client
        .from("room")
        .select()
        .eq("room_owner", value: userId)
        .execute()
        .value
    
    let roomId = roomData[0].room_id
    
    guard let image = UIImage(named: roomPicture) else {
        print("Error: Profile image not found")
        return
    }
    
    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
        print("Error: Failed to convert image")
        return
    }
    
    do {
        try await client.storage
            .from("zorion_bucket")
            .upload("roomPicture/\(roomId)/\(roomPicture)",
                    data: imageData,
                    options: FileOptions(
                        cacheControl: "3600",
                        contentType: "image/jpeg",
                        upsert: false
                    )
            )
        
        print("✅ Uploading profile picture success")
    } catch {
        print("❌ Uploading profile picture failed: \(error.localizedDescription)")
        return
    }
}

// insert room picture ke table room
func insertRoomPicture() async throws {
    let roomPicture: String = UserDefaults.standard.string(forKey: "userRoomPicture")!
    let userId: String = UserDefaults.standard.string(forKey: "userId")!
    
    let roomData: [RoomData] = try await client
        .from("room")
        .select()
        .eq("room_owner", value: userId)
        .execute()
        .value
    
    let roomId = roomData[0].room_id
    
    // nebeng untuk insert room member pas creator buat room
    try await insertRoomMember(roomId: roomId)
    
    let publicUrl = try client.storage
        .from("zorion_bucket")
        .getPublicURL(path: "roomPicture/\(roomId)/\(roomPicture)")
    
    try await client
        .from("room")
        .update(["room_picture": publicUrl])
        .eq("room_id", value: roomId)
        .execute()
}

// fetch creator room data
func fetchCreatorRoom() async throws -> RoomModel {
    let userId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    let userUUID = UUID(uuidString: userId)
    
    let result: RoomModel = try await client
        .from("room")
        .select()
        .eq("room_owner", value: userUUID)
        .single()
        .execute()
        .value
    
    return result
}

// fetch semua room yang ada
func fetchAllRoom() async throws -> [RoomModel] {
    let result: [RoomModel] = try await client
        .from("room")
        .select()
        .execute()
        .value
    
    return result
}

// fetch detail room data
func fetchRoomDetail(roomId: UUID) async throws -> RoomModel {
    let result: RoomModel = try await client
        .from("room")
        .select()
        .eq("room_id", value: roomId)
        .single()
        .execute()
        .value
    
    return result
}

// insert room member
func insertRoomMember(roomId: UUID) async throws {
    let userId: UUID = try await client.auth.user().id
    let data = InsertRoomMember(user_id: userId, room_id: roomId)
    
    try await client
        .from("room_members")
        .insert(data)
        .execute()
}

// fetch community room user yang sudah join
func fetchUserCommunityRoom() async throws -> [RoomModel] {
    let userId: UUID = try await client.auth.user().id
    
    let data: [CommunityRoomUser] = try await client
        .from("room_members")
        .select("*, room(*)")
        .eq("user_id", value: userId)
        .execute()
        .value
    
    let rooms = data.map { $0.room }
    
    return rooms
}

// cek apakah user sudah join di room atau belum
func userJoinRoom(roomId: UUID) async throws -> Bool {
    let userId: UUID = try await client.auth.user().id
    
    let result: [RoomMember] = try await client
        .from("room_members")
        .select("*")
        .eq("room_id", value: roomId)
        .eq("user_id", value: userId)
        .execute()
        .value
    
    if result.isEmpty {
        return false
    } else {
        return true
    }
}

// fetch semua room member
func fetchAllRoomMember(roomId: UUID) async throws -> [UserModel] {
    let result: [AllRoomMember] = try await client
        .from("room_members")
        .select("*, user(*)")
        .eq("room_id", value: roomId)
        .execute()
        .value
    
    let users = result.map { $0.user }
    
    return users
}

// insert chat kedalam tabel
func insertChat(roomId: UUID, message: String, messageImage: String? = nil) async throws {
    let userId: UUID = try await client.auth.user().id
    
    let data = InsertMessage(user_id: userId, room_id: roomId, message_image: messageImage, message: message)
    
    try await client
        .from("messages")
        .insert(data)
        .execute()
}

// insert gambar chat kedalam bucket storage
func insertChatImage(image: UIImage, roomId: UUID) async throws -> String {
    let userId: UUID = try await client.auth.user().id
    let imageData = image.jpegData(compressionQuality: 0.5)!
    let fileName = "\(Int(Date().timeIntervalSince1970))"
    
    try await client.storage
        .from("zorion_bucket")
        .upload("chatImage/\(roomId)/\(userId)/\(fileName)",
                data: imageData,
                options: FileOptions(
                    cacheControl: "3600",
                    contentType: "image/jpeg",
                    upsert: false
                )
        )
    
    let publicURL = try client.storage
        .from("zorion_bucket")
        .getPublicURL(path: "chatImage/\(roomId)/\(userId)/\(fileName)")
    
    return publicURL.absoluteString
}

// untuk fetch data message
func fetchMessage(roomId: UUID) async throws -> [MessageModel] {
    let result: [MessageModel] = try await client
        .from("messages")
        .select("*, user(*), room(*)")
        .eq("room_id", value: roomId)
        .execute()
        .value
    
    return result
}

// untuk fetch realtime data
func fetchSingleMessage(messageId: Int) async throws -> MessageModel? {
    let result: [MessageModel] = try await client
        .from("messages")
        .select("*, user(*), room(*)")
        .eq("id", value: messageId)
        .execute()
        .value
    
    return result.first
}

// untuk insert vote kedalam tabel
func insertVote(roomId: UUID, question: String, choices: [VoteOption]) async throws {
    let data = InsertVoteModel(room_id: roomId, question: question)
    
    let result: InsertResponse = try await client
        .from("vote")
        .insert(data)
        .select("vote_id")
        .single()
        .execute()
        .value
    
    let voteId = result.vote_id
    
    let choicesData = choices.map { option in
        InsertChoiceModel(
            vote_id: voteId,
            choice: option.text
        )
    }
    
    try await client
        .from("vote_choices")
        .insert(choicesData)
        .execute()
}

// untuk fetch vote
func fetchVote(roomId: UUID) async throws -> [VoteModel] {
    let result: [VoteModel] = try await client
        .from("vote")
        .select("*, vote_choices(*, vote_results(count))")
        .eq("room_id", value: roomId)
        .order("created_at", ascending: false)
        .execute()
        .value
    
    return result
}

// untuk vote nya
func inputVote(voteId: UUID, choiceId: UUID) async throws {
    let userId: UUID = try await client.auth.user().id
    let data = InputVoteModel(vote_id: voteId, choice_id: choiceId, user_id: userId)
    
    try await client
        .from("vote_results")
        .insert(data)
        .execute()
}

// untuk cek apakah vote ada di room creator itu sendiri
func checkIsCreatorRoom(roomId: UUID) async throws -> Bool {
    let userId: UUID = try await client.auth.user().id
    
    let result: RoomModel = try await client
        .from("room")
        .select("*")
        .eq("room_id", value: roomId)
        .single()
        .execute()
        .value
    
    if result.room_owner == userId {
        return true
    } else {
        return false
    }
}

// untuk cek apakah user tesebut sudah vote atau belum
func fetchUserVoteChoice(voteId: UUID) async throws -> UUID? {
    let userId = try await client.auth.user().id
    
    struct VoteCheckResult: Codable {
        let choice_id: UUID
    }
    
    let result: [VoteCheckResult] = try await client
        .from("vote_results")
        .select("choice_id")
        .eq("vote_id", value: voteId)
        .eq("user_id", value: userId)
        .limit(1)
        .execute()
        .value
    
    return result.first?.choice_id
}

// fetch semua member kecuali diri kita sendiri sebagai creator
func fetchOtherMember(roomId: UUID) async throws -> [UserModel] {
    let userId: UUID = try await client.auth.user().id
    
    let result: [AllRoomMember] = try await client
        .from("room_members")
        .select("*, user(*)")
        .eq("room_id", value: roomId)
        .neq("user_id", value: userId)
        .execute()
        .value
    
    let users = result.map { $0.user }
    
    return users
}

// untuk delete member
func deleteMember(userId: UUID, roomId: UUID) async throws {
    try await client
        .from("room_members")
        .delete()
        .eq("user_id", value: userId)
        .eq("room_id", value: roomId)
        .execute()
}

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
func insertChat(roomId: UUID, message: String, messageImage: UIImage? = nil) async throws {
    let userId: UUID = try await client.auth.user().id
    var imageLink: String = ""
    
    if messageImage != nil {
        imageLink = try await insertChatImage(image: messageImage!, roomId: roomId)
    }
    
    let data = InsertMessage(user_id: userId, room_id: roomId, message_image: imageLink, message: message)
    
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

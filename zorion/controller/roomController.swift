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

// add user kedalam tabel user
func addRoomData(roomName: String, roomDesc: String) async throws {
    let roomOwner = try await client.auth.user().id
    let room = InsertRoom(room_owner: roomOwner, room_name: roomName, room_desc: roomDesc)
    
    do {
        try await client
            .from("room")
            .insert(room)
            .execute()
    } catch {
        print("❌ Uploading profile picture failed: \(error.localizedDescription)")
        return
    }
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

// insert profile picture ke table user
func insertRoomPicture() async throws  {
    let roomPicture: String = UserDefaults.standard.string(forKey: "userRoomPicture")!
    let userId: String = UserDefaults.standard.string(forKey: "userId")!
    
    let roomData: [RoomData] = try await client
        .from("room")
        .select()
        .eq("room_owner", value: userId)
        .execute()
        .value
    
    let roomId = roomData[0].room_id
    
    do {
        let publicUrl = try client.storage
            .from("zorion_bucket")
            .getPublicURL(path: "roomPicture/\(roomId)/\(roomPicture)")
        
        try await client
            .from("room")
            .update(["room_picture": publicUrl])
            .eq("room_id", value: roomId)
            .execute()
        
        print("✅ Updating room picture success")
    } catch {
        print("❌ Updating room picture failed: \(error.localizedDescription)")
        return
    }
}

// fetch creator room data
func fetchCreatorRoom() async throws -> RoomModel {
    let userId: String = UserDefaults.standard.string(forKey: "userId") ?? "41485a82-94ce-4050-b60a-8d738fb72a0d"
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

//
//  updateController.swift
//  zorion
//
//  Created by Jose on 06/12/25.
//

import Foundation
import Supabase
import UIKit

private let client = SupabaseManager.shared.client


// update username
func usernameUpdate(newUsername: String) async throws {
    let userId: UUID = try await client.auth.user().id
    
    try await client
        .from("user")
        .update(["username" : newUsername])
        .eq("user_id", value: userId)
        .execute()
}

// update room name
func roomNameUpdate(newName: String) async throws {
    let roomId: UUID = UUID(uuidString: UserDefaults.standard.string(forKey: "userRoomId")!)!
    
    try await client
        .from("room")
        .update(["room_name" : newName])
        .eq("room_id", value: roomId)
        .execute()
}

// update room description
func roomDescriptionUpdate(newDescription: String) async throws {
    let roomId: UUID = UUID(uuidString: UserDefaults.standard.string(forKey: "userRoomId")!)!
    
    try await client
        .from("room")
        .update(["room_desc" : newDescription])
        .eq("room_id", value: roomId)
        .execute()
}

// update profile picture
func userPictureUpdate(newPicture: String) async throws {
    let userId: UUID = try await client.auth.user().id
    
    // ambil data sebelumnya
    let fileName = try await client.storage
        .from("zorion_bucket")
        .list(
            path: "userPicture/\(userId)/"
        )
    
    // remove data yang udah ada
    try await client.storage
        .from("zorion_bucket")
        .remove(paths: ["userPicture/\(userId)/\(fileName[0].name)"])
    
    // upload data yang baru
    guard let image = UIImage(named: newPicture) else {
        print("Error: Profile image not found")
        return
    }
    
    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
        print("Error: Failed to convert image")
        return
    }
    
    try await client.storage
        .from("zorion_bucket")
        .upload("userPicture/\(userId)/\(newPicture)",
                data: imageData,
                options: FileOptions(
                    cacheControl: "3600",
                    contentType: "image/jpeg",
                    upsert: false
                )
        )
    
    // ambil link gambarnya
    let publicUrl = try client.storage
        .from("zorion_bucket")
        .getPublicURL(path: "userPicture/\(userId)/\(newPicture)")
    
    // update di table link nya
    try await client
        .from("user")
        .update(["profile_picture" : publicUrl])
        .eq("user_id", value: userId)
        .execute()
}

// update room picture
func roomPictureUpdate(newPicture: String) async throws {
    let roomId: UUID = UUID(uuidString: UserDefaults.standard.string(forKey: "userRoomId")!)!
    
    // ambil data sebelumnya
    let fileName = try await client.storage
        .from("zorion_bucket")
        .list(
            path: "roomPicture/\(roomId)/"
        )
    
    // remove data yang udah ada
    try await client.storage
        .from("zorion_bucket")
        .remove(paths: ["roomPicture/\(roomId)/\(fileName[0].name)"])
    
    // upload data yang baru
    guard let image = UIImage(named: newPicture) else {
        print("Error: Profile image not found")
        return
    }
    
    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
        print("Error: Failed to convert image")
        return
    }
    
    try await client.storage
        .from("zorion_bucket")
        .upload("roomPicture/\(roomId)/\(newPicture)",
                data: imageData,
                options: FileOptions(
                    cacheControl: "3600",
                    contentType: "image/jpeg",
                    upsert: false
                )
        )
    
    // ambil link gambarnya
    let publicUrl = try client.storage
        .from("zorion_bucket")
        .getPublicURL(path: "roomPicture/\(roomId)/\(newPicture)")
    
    // update di table link nya
    try await client
        .from("room")
        .update(["room_picture" : publicUrl])
        .eq("room_id", value: roomId)
        .execute()
}

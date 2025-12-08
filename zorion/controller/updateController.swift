//
//  updateController.swift
//  zorion
//
//  Created by Jose on 06/12/25.
//

import Foundation
import Supabase
import UIKit
import PhotosUI

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

// menambahkan creator baru
func addNewCreator(roomName: String, roomDesc: String, roomPicture: String) async throws {
    let userId: UUID = try await client.auth.user().id
    
    // update status creator di table user
    try await client
        .from("user")
        .update(["content_creator" : true])
        .eq("user_id", value: userId)
        .execute()
    
    // insert room data ke tabel
    let room = InsertRoom(room_owner: userId, room_name: roomName, room_desc: roomDesc)
    try await client
        .from("room")
        .insert(room)
        .execute()
    
    // upload room picture kedalam bucket
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
    
    // update data di tabel room
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

// update pakai custom profile picture
func userPictureUpdateCustom(uiImage: UIImage) async throws {
    let userId: UUID = try await client.auth.user().id
    
    let oldFiles = try await client.storage
        .from("zorion_bucket")
        .list(path: "userPicture/\(userId)/")
    
    if !oldFiles.isEmpty {
        let pathsToRemove = oldFiles.map { "userPicture/\(userId)/\($0.name)" }
        try await client.storage
            .from("zorion_bucket")
            .remove(paths: pathsToRemove)
    }

    let maxDimension: CGFloat = 400
    
    var newSize = uiImage.size
    if uiImage.size.width > maxDimension || uiImage.size.height > maxDimension {
        let aspectRatio = uiImage.size.width / uiImage.size.height
        if uiImage.size.width > uiImage.size.height {
            newSize = CGSize(width: maxDimension, height: maxDimension / aspectRatio)
        } else {
            newSize = CGSize(width: maxDimension * aspectRatio, height: maxDimension)
        }
    }
    
    let renderer = UIGraphicsImageRenderer(size: newSize)
    let resizedImage = renderer.image { _ in
        uiImage.draw(in: CGRect(origin: .zero, size: newSize))
    }

    guard let imageData = resizedImage.jpegData(compressionQuality: 0.5) else {
        print("Error: Failed to convert custom image")
        return
    }

    let newFileName = "\(UUID().uuidString).jpg"
    
    try await client.storage
        .from("zorion_bucket")
        .upload("userPicture/\(userId)/\(newFileName)",
                data: imageData,
                options: FileOptions(
                    cacheControl: "3600",
                    contentType: "image/jpeg",
                    upsert: false
                )
        )

    let publicUrl = try client.storage
        .from("zorion_bucket")
        .getPublicURL(path: "userPicture/\(userId)/\(newFileName)")
    
    try await client
        .from("user")
        .update(["profile_picture" : publicUrl])
        .eq("user_id", value: userId)
        .execute()
        
    print("✅ Upload Success: \(publicUrl)")
}

// update pakai custom room picture
func roomPictureUpdateCustom(uiImage: UIImage) async throws {
    let roomId: UUID = UUID(uuidString: UserDefaults.standard.string(forKey: "userRoomId")!)!
    
    let oldFiles = try await client.storage
        .from("zorion_bucket")
        .list(path: "roomPicture/\(roomId)/")
    
    if !oldFiles.isEmpty {
        let pathsToRemove = oldFiles.map { "roomPicture/\(roomId)/\($0.name)" }
        try await client.storage
            .from("zorion_bucket")
            .remove(paths: pathsToRemove)
    }
    
    let maxDimension: CGFloat = 400
    
    var newSize = uiImage.size
    if uiImage.size.width > maxDimension || uiImage.size.height > maxDimension {
        let aspectRatio = uiImage.size.width / uiImage.size.height
        if uiImage.size.width > uiImage.size.height {
            newSize = CGSize(width: maxDimension, height: maxDimension / aspectRatio)
        } else {
            newSize = CGSize(width: maxDimension * aspectRatio, height: maxDimension)
        }
    }
    
    let renderer = UIGraphicsImageRenderer(size: newSize)
    let resizedImage = renderer.image { _ in
        uiImage.draw(in: CGRect(origin: .zero, size: newSize))
    }

    guard let imageData = resizedImage.jpegData(compressionQuality: 0.5) else {
        print("Error: Failed to convert custom image")
        return
    }

    let newFileName = "\(UUID().uuidString).jpg"
    
    try await client.storage
        .from("zorion_bucket")
        .upload("roomPicture/\(roomId)/\(newFileName)",
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
        .getPublicURL(path: "roomPicture/\(roomId)/\(newFileName)")
    
    // update di table link nya
    try await client
        .from("room")
        .update(["room_picture" : publicUrl])
        .eq("room_id", value: roomId)
        .execute()
}

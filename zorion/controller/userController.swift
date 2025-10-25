//
//  userController.swift
//  zorion
//
//  Created by Jose Andreas on 23/10/25.
//

import Foundation
import Supabase
import UIKit

private let client = SupabaseManager.shared.client

// add user kedalam tabel user
func addUserData(username: String, contentCreator: Bool) async throws {
    let user = InsertUser(username: username, content_creator: contentCreator)
    
    do {
        try await client
            .from("user")
            .insert(user)
            .execute()
    } catch {
        print("❌ Inserting user to database failed: \(error.localizedDescription)")
        return
    }
}

// upload profile picture user kedalam bucket
func uploadProfilePicture() async throws {
    let profilePicture: String = UserDefaults.standard.string(forKey: "userProfilePicture")!
    let userId: String = UserDefaults.standard.string(forKey: "userId")!
    
    guard let image = UIImage(named: profilePicture) else {
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
            .upload("userPicture/\(userId)/\(profilePicture)",
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
func insertProfilePicture() async throws  {
    let profilePicture: String = UserDefaults.standard.string(forKey: "userProfilePicture")!
    let userId: String = UserDefaults.standard.string(forKey: "userId")!
    
    do {
        let publicUrl = try client.storage
            .from("zorion_bucket")
            .getPublicURL(path: "userPicture/\(userId)/\(profilePicture)")
        
        try await client
            .from("user")
            .update(["profile_picture": publicUrl])
            .eq("user_id", value: userId)
            .execute()
        
        print("✅ Updating profile picture success")
    } catch {
        print("❌ Updating profile picture failed: \(error.localizedDescription)")
        return
    }
}

// cek apakah sudah ada di tabel user jika pakai oauth
func checkUserData() async throws -> Int {
    let userId: String = UserDefaults.standard.string(forKey: "userId")!
    
    let result = try await client
        .from("user")
        .select("user_id", count: .exact)
        .eq("user_id", value: userId)
        .limit(1)
        .execute()
    
    return result.count ?? 0
}

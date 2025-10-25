//
//  newUserController.swift
//  zorion
//
//  Created by Jose Andreas on 17/10/25.
//

import Foundation
import UIKit

// register user lewat email dan password
func registerNewUser() async throws {
    let email: String = UserDefaults.standard.string(forKey: "userEmail") ?? ""
    let password: String = UserDefaults.standard.string(forKey: "userPassword") ?? ""
    let contentCreator: Bool = UserDefaults.standard.bool(forKey: "isContentCreator")
    let username: String = UserDefaults.standard.string(forKey: "userUsername")!
    let roomName: String = UserDefaults.standard.string(forKey: "roomName") ?? ""
    let roomDesc: String = UserDefaults.standard.string(forKey: "roomDesc") ?? ""
    let useOauth: Bool = UserDefaults.standard.bool(forKey: "useOauth")
    
    if !useOauth {
        print("⚙️ Registering user...")
        try await AuthController().registerUser(email: email, password: password)
        print("✅ Registering user completed")
    }
    
    print("⚙️ Inserting user to database...")
    try await addUserData(username: username, contentCreator: contentCreator)
    print("✅ Inserting user to database completed")
    
    print("⚙️ Uploading user profile picture to database...")
    try await uploadProfilePicture()
    print("✅ Uploading user profile picture to database completed")
    
    print("⚙️ Updating user profile picture to database...")
    try await insertProfilePicture()
    print("✅ Updating user profile picture to database completed")
    
    if contentCreator {
        print("⚙️ Inserting room to database...")
        try await addRoomData(roomName: roomName, roomDesc: roomDesc)
        print("✅ Inserting room to database completed")
        
        print("⚙️ Uploading room picture to database...")
        try await uploadRoomPicture()
        print("✅ Uploading room picture to database completed")
        
        print("⚙️ Updating room picture to database...")
        try await insertRoomPicture()
        print("✅ Updating room picture to database completed")
    }
}

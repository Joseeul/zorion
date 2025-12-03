//
//  authController.swift
//  zorion
//
//  Created by Jose Andreas on 17/10/25.
//

import Foundation
import Supabase
import AuthenticationServices
import SwiftJWT

struct AuthController {
    private let client = SupabaseManager.shared.client
    
    // register user dengan email dan password
    func registerUser(email: String, password: String) async throws {
        try await client.auth.signUp(email: email, password: password)
        
        let user = try await client.auth.user()
        let userId = user.id.uuidString
        UserDefaults.standard.set(userId, forKey: "userId")
        let jwt = try await generateStreamToken(userId: userId)
        UserDefaults.standard.set(jwt, forKey: "JWT")
        
        print("✅ Register with email and password success")
    }
    
    // login user dengan email dan password
    func loginUser(email: String, password: String) async throws {
        try await client.auth.signIn(email: email, password: password)
        
        let user = try await client.auth.user()
        let userId = user.id.uuidString
        UserDefaults.standard.set(userId, forKey: "userId")
        
        let jwt = try await generateStreamToken(userId: userId)
        
        UserDefaults.standard.set(jwt, forKey: "JWT")
        
        try await client.auth.getClaims()
        
        print("✅ Login with email and password success")
    }
    
    // GOOGLE auth
    func googleAuth() async throws {
        try await client.auth.signInWithOAuth(
            provider: .google,
            redirectTo: URL(string: "com.app.zorion://login-callback")!
        )
        
        let user = try await client.auth.user()
        let userId = user.id.uuidString
        UserDefaults.standard.set(userId, forKey: "userId")
        
        print("✅ Google auth success")
    }
    
    // DISCORD auth
    func discordAuth() async throws {
        try await client.auth.signInWithOAuth(
            provider: .discord,
            redirectTo: URL(string: "com.app.zorion://login-callback")!
        )
        
        let user = try await client.auth.user()
        let userId = user.id.uuidString
        UserDefaults.standard.set(userId, forKey: "userId")
        
        print("✅ Discord auth success")
    }
    
    // SIGN OUT
    func signOutUser() async throws {
        try await client.auth.signOut()
        
        UserDefaults.standard.set("", forKey: "userId")
        
        print("✅ Sign out success")
    }
}

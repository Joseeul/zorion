//
//  authController.swift
//  zorion
//
//  Created by Jose Andreas on 17/10/25.
//

import Foundation
import Supabase
import AuthenticationServices

struct AuthController {
    private let client = SupabaseManager.shared.client
    
    // register user dengan email dan password
    func registerUser(email: String, password: String) async -> Bool {
        do {
            try await client.auth.signUp(email: email, password: password)
            
            print("✅ Register with email and password success")
            return true
        } catch {
            print("❌ Register with email and password failed: \(error.localizedDescription)")
            return false
        }
    }
    
    // login user dengan email dan password
    func loginUser(email: String, password: String) async -> Bool {
        do {
            try await client.auth.signIn(email: email, password: password)
            
            print("✅ Login with email and password success")
            return true
        } catch {
            print("❌ Login with email and password failed: \(error.localizedDescription)")
            return false
        }
    }
    
    // GOOGLE auth
    func googleAuth() async -> Bool {
        do {
            try await client.auth.signInWithOAuth(
                provider: .google,
                redirectTo: URL(string: "com.app.zorion://login-callback")!
            )
            
            print("✅ Google auth success")
            return true
        } catch {
            print("❌ Google auth failed: \(error.localizedDescription)")
            return false
        }
    }
    
    // DISCORD auth
    func discordAuth() async -> Bool {
        do {
            try await client.auth.signInWithOAuth(
                provider: .discord,
                redirectTo: URL(string: "com.app.zorion://login-callback")!
            )
            
            print("✅ Discord auth success")
            return true
        } catch {
            print("❌ Discord auth failed: \(error.localizedDescription)")
            return false
        }
    }
    
    // SIGN OUT
    func signOutUser() async -> Bool {
        do {
            try await client.auth.signOut()
            
            print("✅ Sign out success")
            return true
        } catch {
            print("❌ Sign out failed: \(error.localizedDescription)")
            return false
        }
    }
}

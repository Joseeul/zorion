//
//  creatorVerifController.swift
//  zorion
//
//  Created by Jose Andreas on 23/10/25.
//

import Foundation

func checkCreatorVerify(platform: String, username: String) async throws -> CreatorVerifyData {
    // endpoint TikTok: /tiktok
    // endpoint YouTube: /youtube
    // endpoint Instagram: /instagram
    
    let lowerCasePlatform = platform.lowercased()
    let lowerCaseUsername = username.lowercased()

    let endpoint = "https://subs-follower-count-api.vercel.app/\(lowerCasePlatform)/\(lowerCaseUsername)"
    
    guard let url = URL(string: endpoint) else {
        throw URLError(.badURL)
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
    
    let creatorVerify = try JSONDecoder().decode(CreatorVerifyData.self, from: data)
    
    return creatorVerify
}

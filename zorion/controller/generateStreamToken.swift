//
//  generateStreamToken.swift
//  zorion
//
//  Created by Jose on 03/12/25.
//

import Foundation

func generateStreamToken(userId: String) async throws -> String {
    
    let endpoint = "https://subs-follower-count-api.vercel.app/audio_room/\(userId)"
    
    guard let url = URL(string: endpoint) else {
        throw URLError(.badURL)
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
    
    let decoded = try JSONDecoder().decode(StreamTokenResponse.self, from: data)
    
    return decoded.token
}

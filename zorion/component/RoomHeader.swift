//
//  RoomHeader.swift
//  zorion
//
//  Created by Jose Andreas on 03/11/25.
//

import SwiftUI

struct RoomHeader: View {
    let imageUrl: URL?
    let roomName: String?
    let roomDesc: String?
    
    var body: some View {
        HStack {
            AsyncImage(url: imageUrl) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(.circle)
                    .frame(width: 42)
            } placeholder: {
                Color.gray.opacity(0.3)
                    .frame(width: 42, height: 42)
                    .overlay(ProgressView())
                    .clipShape(.circle)
            }
            
            VStack(alignment: .leading) {
                Text(roomName ?? "")
                    .fontWeight(.semibold)
                
                Text(roomDesc ?? "")
                    .font(.footnote)
                    .foregroundStyle(.zorionGray)
            }
        }
        .padding(.vertical, 8)
    }
}

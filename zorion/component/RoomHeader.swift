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
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 42, height: 42)
                    .clipShape(Circle())
            } placeholder: {
                Color.gray.opacity(0.3)
                    .frame(width: 42, height: 42)
                    .overlay(
                        ProgressView()
                            .tint(.gray)
                    )
                    .clipShape(.circle)
            }
            
            VStack(alignment: .leading) {
                Text(roomName ?? "")
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Text(roomDesc ?? "")
                    .font(.footnote)
                    .foregroundStyle(.zorionGray)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .contentShape(Rectangle())
    }
}

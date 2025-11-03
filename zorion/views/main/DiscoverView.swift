//
//  DiscoverView.swift
//  zorion
//
//  Created by Jose Andreas on 02/11/25.
//

import SwiftUI

struct DiscoverView: View {
    @State private var searchQuery: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField(
                    "Search...",
                    text: $searchQuery
                )
                .padding(.vertical, 12)
                .padding(.horizontal, 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            Color.zorionGray,
                            lineWidth: 0.5
                        )
                )
                
                Button(action: {}, label: {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 16, height: 16)
                        .clipShape(.circle)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                })
                .padding(14)
                .background(.zorionPrimary)
                .clipShape(Circle())
            }
            
            Text("Discover popular rooms")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 12)
            
            ScrollView {
                RoomHeader(imageUrl: "chat_blue", roomName: "Joseeul Chill Room", roomDesc: "Tempatnya ngechill sambil ngobrolin masa depan")
                
                RoomHeader(imageUrl: "chat_dark_blue", roomName: "Joseeul Chill Room", roomDesc: "Tempatnya ngechill sambil ngobrolin masa depan")
                
                RoomHeader(imageUrl: "chat_pink", roomName: "Joseeul Chill Room", roomDesc: "Tempatnya ngechill sambil ngobrolin masa depan")
            }
        }
        .padding()
    }
}

#Preview {
    DiscoverView()
}

//
//  RoomHeader.swift
//  zorion
//
//  Created by Jose Andreas on 03/11/25.
//

import SwiftUI

struct RoomHeader: View {
    let imageUrl: String
    let roomName: String
    let roomDesc: String
    
    var body: some View {
        HStack {
            Image(imageUrl)
                .resizable()
                .scaledToFit()
                .clipShape(.circle)
                .frame(width: 42)
            
            VStack(alignment: .leading) {
                Text(roomName)
                    .fontWeight(.semibold)
                
                Text(roomDesc)
                    .font(.footnote)
                    .foregroundStyle(.zorionGray)
            }
        }
        .padding(.vertical, 8)
    }
}

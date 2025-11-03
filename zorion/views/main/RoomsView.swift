//
//  RoomsView.swift
//  zorion
//
//  Created by Jose Andreas on 02/11/25.
//

import SwiftUI

struct RoomsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("profile_orange")
                    .resizable()
                    .scaledToFit()
                    .clipShape(.circle)
                    .frame(width: 42)
                
                VStack(alignment: .leading) {
                    Text("Welcome back!")
                        .font(.subheadline)
                        .foregroundStyle(.zorionGray)
                        .fontWeight(.semibold)
                    
                    Text("Joseeul")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Your room")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 12)
            
            RoomHeader(imageUrl: "chat_green", roomName: "Joseeul Chill Room", roomDesc: "Tempatnya ngechill sambil ngobrolin masa depan")
            
            Text("Community room")
                .font(.title2)
                .fontWeight(.bold)
            
            RoomHeader(imageUrl: "chat_blue", roomName: "Joseeul Chill Room", roomDesc: "Tempatnya ngechill sambil ngobrolin masa depan")
            
            RoomHeader(imageUrl: "chat_dark_blue", roomName: "Joseeul Chill Room", roomDesc: "Tempatnya ngechill sambil ngobrolin masa depan")
            
            RoomHeader(imageUrl: "chat_pink", roomName: "Joseeul Chill Room", roomDesc: "Tempatnya ngechill sambil ngobrolin masa depan")
            
            Spacer()
        }
        .padding()
    }
}

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

#Preview {
    RoomsView()
}

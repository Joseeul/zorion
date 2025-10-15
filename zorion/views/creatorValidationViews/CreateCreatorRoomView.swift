//
//  CreateCreatorRoom.swift
//  zorion
//
//  Created by Jose Andreas on 13/10/25.
//

import SwiftUI

struct CreateCreatorRoomView: View {
    @State private var roomName: String = ""
    @State private var roomDesc: String = ""
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Let's set up your")
                .font(.largeTitle)
                .fontWeight(.bold)
            + Text(" own room!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.zorionPrimary)
            
            Text("Room name")
                .font(.subheadline)
                .padding(.top, 8)
            
            TextField(
                "Enter your room name",
                text: $roomName
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
            .padding(.top, 4)
            .disableAutocorrection(true)
            
            Text("Room description")
                .font(.subheadline)
                .padding(.top, 8)
            
            TextField(
                "Enter your room description",
                text: $roomDesc
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
            .padding(.top, 4)
            .disableAutocorrection(true)
            
            Text("\(roomDesc.count)/30 characters")
                .font(.caption2)
                .foregroundColor(.zorionGray)
                .padding(.top, 4)
            
            Text("Room picture")
                .font(.subheadline)
                .padding(.top, 8)
            
            Button(action: {
                path.append(authRoute.CreateUsernameView)
            }, label: {
                Text("Create room")
                    .frame(maxWidth: .infinity)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            })
            .frame(maxWidth: .infinity)
            .padding([.top, .bottom], 12)
            .padding([.trailing, .leading], 8)
            .background(Color.zorionPrimary)
            .foregroundStyle(.white)
            .cornerRadius(8)
            .padding(.top, 16)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    CreateCreatorRoomView(path: .constant(NavigationPath()))
}

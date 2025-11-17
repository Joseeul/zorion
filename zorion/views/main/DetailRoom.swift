//
//  DetailRoom.swift
//  zorion
//
//  Created by Jose Andreas on 04/11/25.
//

import SwiftUI

struct DetailRoom: View {
    @State private var isJoin: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("chat_red")
                    .resizable()
                    .scaledToFit()
                    .clipShape(.circle)
                    .frame(width: 42)
                
                VStack(alignment: .leading) {
                    Text("Room Name")
                        .fontWeight(.semibold)
                    
                    Text("Room Desc")
                        .font(.footnote)
                        .foregroundStyle(.zorionGray)
                }
            }
            .padding(.bottom, 8)
            
            if isJoin == false {
                Button(action: {}, label: {
                    Text("Join this room")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                })
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom], 12)
                .padding([.trailing, .leading], 8)
                .fontWeight(.semibold)
                .background(.zorionPrimary)
                .foregroundStyle(.white)
                .cornerRadius(8)
                
                Text("Room participants")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 6)
                
                HStack {
                    Image("profile_blue")
                        .resizable()
                        .scaledToFit()
                        .clipShape(.circle)
                        .frame(width: 42)
                    
                    Text("userName")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Button(action: {}, label: {
                    Text("Vote")
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                })
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom], 12)
                .padding([.trailing, .leading], 8)
                .background(.zorionSettings)
                .foregroundStyle(.zorionGray)
                .cornerRadius(8)
                .padding(.top, 8)
                
                Button(action: {}, label: {
                    Text("Chats")
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                })
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom], 12)
                .padding([.trailing, .leading], 8)
                .background(.zorionSettings)
                .foregroundStyle(.zorionGray)
                .cornerRadius(8)
                .padding(.top, 8)
                
                Button(action: {}, label: {
                    Text("Voice & video")
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                })
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom], 12)
                .padding([.trailing, .leading], 8)
                .background(.zorionSettings)
                .foregroundStyle(.zorionGray)
                .cornerRadius(8)
                .padding(.top, 8)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    DetailRoom()
}

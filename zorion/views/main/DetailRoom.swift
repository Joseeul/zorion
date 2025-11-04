//
//  DetailRoom.swift
//  zorion
//
//  Created by Jose Andreas on 04/11/25.
//

import SwiftUI

struct DetailRoom: View {
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
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    DetailRoom()
}

//
//  HomeView.swift
//  zorion
//
//  Created by Jose Andreas on 24/10/25.
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
                    Text("Joseeul")
                }
            }
            
            Text("ROOMS VIEW")
            
            Button(action: {
                Task {
                    try await AuthController().signOutUser()
                }
                UserDefaults.standard.set(false, forKey: "isLogin")
            }, label: {
                Text("LOGOUT")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            })
            .frame(maxWidth: .infinity)
            .padding([.top, .bottom], 12)
            .padding([.trailing, .leading], 8)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.zorionGray, lineWidth: 0.5)
            )
            .padding(.bottom, 8)
        }
        .padding()
    }
}

#Preview {
    RoomsView()
}

//
//  ProfileView.swift
//  zorion
//
//  Created by Jose Andreas on 02/11/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
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
    ProfileView()
}

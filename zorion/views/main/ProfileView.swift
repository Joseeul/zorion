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
            Image("profile_orange")
                .resizable()
                .scaledToFit()
                .clipShape(.circle)
                .frame(width: 70)
            
            Text("Joseeul")
                .fontWeight(.semibold)
                .padding(.vertical, 8)
            
            Text("Joined since 2025")
                .font(.footnote)
            
            Text("Settings")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: {}, label: {
                Text("Edit profile")
                
                Spacer()
                
                Image(systemName: "chevron.right")
            })
            .frame(maxWidth: .infinity)
            .padding([.top, .bottom], 12)
            .padding([.trailing, .leading], 8)
            .background(.zorionSettings)
            .foregroundStyle(.zorionGray)
            .cornerRadius(8)
            .padding(.bottom, 8)
            
            Button(action: {}, label: {
                Text("Appearances")
                
                Spacer()
                
                Image(systemName: "chevron.right")
            })
            .frame(maxWidth: .infinity)
            .padding([.top, .bottom], 12)
            .padding([.trailing, .leading], 8)
            .background(.zorionSettings)
            .foregroundStyle(.zorionGray)
            .cornerRadius(8)
            
            Spacer()
            
            Button(action: {
                Task {
                    try await AuthController().signOutUser()
                }
                UserDefaults.standard.set(false, forKey: "isLogin")
                UserDefaults.standard.removeObject(forKey: "userEmail")
                UserDefaults.standard.removeObject(forKey: "userPassword")
                UserDefaults.standard.removeObject(forKey: "isContentCreator")
                UserDefaults.standard.removeObject(forKey: "userUsername")
                UserDefaults.standard.removeObject(forKey: "roomName")
                UserDefaults.standard.removeObject(forKey: "roomDesc")
                UserDefaults.standard.removeObject(forKey: "useOauth")
                UserDefaults.standard.removeObject(forKey: "userId")
            }, label: {
                Text("LOGOUT")
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
        }
        .padding()
    }
}

#Preview {
    ProfileView()
}

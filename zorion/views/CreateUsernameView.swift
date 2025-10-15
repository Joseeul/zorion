//
//  CreateUsernameView.swift
//  zorion
//
//  Created by Jose Andreas on 13/10/25.
//

import SwiftUI

struct CreateUsernameView: View {
    @Binding var path: NavigationPath
    @State private var username: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("What should")
                .font(.largeTitle)
                .fontWeight(.bold)
            + Text(" we call you?")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.zorionPrimary)
            
            Text("Enter a display name so your friends can recognize you easily.")
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 8)
            
            TextField(
                "Username",
                text: $username
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
            .padding(.top, 8)
            .disableAutocorrection(true)
            
            Button(action: {
                path.append(authRoute.CreateProfilePictureView)
            }, label: {
                Text("Submit")
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
            .padding(.top, 8)
            
            Spacer()
        }
        .onTapGesture {
            hideKeyboard()
        }
        .padding()
    }
}

#Preview {
    CreateUsernameView(path: .constant(NavigationPath()))
}

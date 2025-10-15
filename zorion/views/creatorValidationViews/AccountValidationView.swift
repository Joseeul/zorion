//
//  AccountValidationView.swift
//  zorion
//
//  Created by Jose Andreas on 13/10/25.
//

import SwiftUI

struct AccountValidationView: View {
    let platform: String
    @Binding var path: NavigationPath
    @State private var name: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Let's validate your")
                .font(.largeTitle)
                .fontWeight(.bold)
            + Text(" \(platform) account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.zorionPrimary)
            
            TextField(
                "Name",
                text: $name
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
                path.append(authRoute.CreateCreatorRoomView)
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
            
            Text("*If you're a content creator, you'll need to validate your account first. If verification is successful, you'll automatically receive a content creator room and a content creator badge. Please note that to earn the content creator badge or creator room, you must have at least 1,000 followers/subscribers on the platform you're validating.")
                .font(.subheadline)
                .italic()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    AccountValidationView(platform: "AppName", path: .constant(NavigationPath()))
}

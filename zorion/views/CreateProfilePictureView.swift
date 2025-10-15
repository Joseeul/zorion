//
//  CreateProfilePictureView.swift
//  zorion
//
//  Created by Jose Andreas on 14/10/25.
//

import SwiftUI

struct CreateProfilePictureView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Select a profile picture that best")
                .font(.largeTitle)
                .fontWeight(.bold)
            + Text(" reflects your persona")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.zorionPrimary)
            
            Text("You can choose to upload your own photo or use a default image.")
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 16)
            
            Button(action: {}, label: {
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
        .padding()
    }
}

#Preview {
    CreateProfilePictureView()
}

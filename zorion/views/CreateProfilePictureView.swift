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
            
            VStack {
                HStack(spacing: 24) {
                    Button(action: {}, label: {
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 32, height: 32)
                            .clipShape(.circle)
                            .foregroundColor(.zorionGray)
                    })
                    .padding(14)
                    .overlay(
                        Circle()
                            .stroke(.zorionGray, lineWidth: 0.5)
                    )
                    
                    Button(action: {}, label: {
                        Image("profile_orange")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(.circle)
                    })
                    .padding(2)
                    .overlay(
                        Circle()
                            .stroke(.zorionGray, lineWidth: 1)
                    )
                    
                    Button(action: {}, label: {
                        Image("profile_black")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(.circle)
                    })
                    .padding(2)
                    .overlay(
                        Circle()
                            .stroke(.zorionGray, lineWidth: 1)
                    )
                    
                    
                    Button(action: {}, label: {
                        Image("profile_red")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(.circle)
                    })
                    .padding(2)
                    .overlay(
                        Circle()
                            .stroke(.zorionGray, lineWidth: 1)
                    )
                }
                
                HStack(spacing: 24) {
                    Button(action: {}, label: {
                        Image("profile_green")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(.circle)
                    })
                    .padding(2)
                    .overlay(
                        Circle()
                            .stroke(.zorionGray, lineWidth: 1)
                    )
                    
                    Button(action: {}, label: {
                        Image("profile_blue")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(.circle)
                    })
                    .padding(2)
                    .overlay(
                        Circle()
                            .stroke(.zorionGray, lineWidth: 1)
                    )
                    
                    Button(action: {}, label: {
                        Image("profile_pink")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(.circle)
                    })
                    .padding(2)
                    .overlay(
                        Circle()
                            .stroke(.zorionGray, lineWidth: 1)
                    )
                    
                    
                    Button(action: {}, label: {
                        Image("profile_dark_blue")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(.circle)
                    })
                    .padding(2)
                    .overlay(
                        Circle()
                            .stroke(.zorionGray, lineWidth: 1)
                    )
                }
                .padding(.top, 8)
            }
            
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

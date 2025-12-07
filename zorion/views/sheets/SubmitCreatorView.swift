//
//  SubmitCreatorView.swift
//  zorion
//
//  Created by Jose on 05/12/25.
//

import SwiftUI

struct SubmitCreatorView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Choose validation platform")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 8)
                
                NavigationLink(destination: PlatformValidationView(plaform: "TikTok")) {
                    HStack {
                        Image("tiktok_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16)
                        
                        Text("Verify with TikTok")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom], 12)
                .padding([.trailing, .leading], 8)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.zorionGray, lineWidth: 0.5)
                )
                .padding(.bottom, 8)
                
                NavigationLink(destination: PlatformValidationView(plaform: "YouTube")) {
                    HStack {
                        Image("youtube_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16)
                        
                        Text("Verify with YouTube")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom], 12)
                .padding([.trailing, .leading], 8)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.zorionGray, lineWidth: 0.5)
                )
                .padding(.bottom, 8)
                
                NavigationLink(destination: PlatformValidationView(plaform: "Instagram")) {
                    HStack {
                        Image("instagram_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16)
                        
                        Text("Verify with Instagram")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom], 12)
                .padding([.trailing, .leading], 8)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.zorionGray, lineWidth: 0.5)
                )
                .padding(.bottom, 8)
                
                Spacer()
            }
            .padding(.top, 30)
            .padding()
            .task {
                if UserDefaults.standard.bool(forKey: "updatedContentCreator") == true {
                    dismiss()
                }
            }
        }
        .tint(.zorionPrimary)
    }
}

#Preview {
    SubmitCreatorView()
}

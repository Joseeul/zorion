//
//  ChooseValidationView.swift
//  zorion
//
//  Created by Jose Andreas on 12/10/25.
//

import SwiftUI

struct ChooseValidationView: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Are you a")
                .font(.largeTitle)
                .fontWeight(.bold)
            + Text(" content creator?")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.zorionPrimary)
            
            Text("Select one of the following platforms for verification.")
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 16)
            
            Group {
                Button(action: {
                    path.append(authRoute.AccountValidationView(platform: "TikTok"))
                }, label: {
                    Image("tiktok_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16)
                    
                    Text("Verify with TikTok")
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
                
                Button(action: {
                    path.append(authRoute.AccountValidationView(platform: "YouTube"))
                }, label: {
                    Image("youtube_logo")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.black)
                        .frame(width: 16)
                    
                    Text("Verify with YouTube")
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
                
                Button(action: {
                    path.append(authRoute.AccountValidationView(platform: "Instagram"))
                }, label: {
                    Image("instagram_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16)
                    
                    Text("Verify with Instagram")
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
                
                Button(action: {
                    path.append(authRoute.CreateUsernameView)
                }, label: {
                    Text("I'm not a content creator")
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
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ChooseValidationView(path: .constant(NavigationPath()))
}

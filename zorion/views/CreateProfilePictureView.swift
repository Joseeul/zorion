//
//  CreateProfilePictureView.swift
//  zorion
//
//  Created by Jose Andreas on 14/10/25.
//

import SwiftUI

struct CreateProfilePictureView: View {
    @State private var selectedProfilePicture: String = ""
    @State private var isShowingAlert: Bool = false
    @State private var isLoading: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    func handleSubmit() async {
        if selectedProfilePicture.isEmpty {
            self.alertTitle = "Missing Input"
            self.alertMessage = "Please choose a profile picture."
            self.isShowingAlert = true
            return
        }
        
        isLoading = true
        
        UserDefaults.standard.set(selectedProfilePicture, forKey: "userProfilePicture")
        
        do {
            isLoading = false
            try await registerNewUser()
            
            UserDefaults.standard.set(true, forKey: "isLogin")
        } catch {
            isLoading = false
            self.alertTitle = "Oops.. There Is An Error"
            self.alertMessage = "\(error.localizedDescription)"
            self.isShowingAlert = true
            return
        }
        
        isLoading = false
    }
    
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
                    
                    Button(action: {
                        selectedProfilePicture = "profile_orange"
                    }, label: {
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
                    
                    Button(action: {
                        selectedProfilePicture = "profile_black"
                    }, label: {
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
                    
                    Button(action: {
                        selectedProfilePicture = "profile_red"
                    }, label: {
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
                    Button(action: {
                        selectedProfilePicture = "profile_green"
                    }, label: {
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
                    
                    Button(action: {
                        selectedProfilePicture = "profile_blue"
                    }, label: {
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
                    
                    Button(action: {
                        selectedProfilePicture = "profile_pink"
                    }, label: {
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
                    
                    
                    Button(action: {
                        selectedProfilePicture = "profile_dark_blue"
                    }, label: {
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
            
            Text("Image selected: \(selectedProfilePicture)")
                .padding(.top, 8)
            
            Button(action: {
                Task {
                    await handleSubmit()
                }
            }, label: {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            })
            .frame(maxWidth: .infinity)
            .padding([.top, .bottom], 12)
            .padding([.trailing, .leading], 8)
            .background(Color.zorionPrimary)
            .foregroundStyle(.white)
            .cornerRadius(8)
            .padding(.top, 8)
            .disabled(isLoading)
            
            Spacer()
        }
        .padding()
        .alert(alertTitle, isPresented: $isShowingAlert, presenting: alertMessage) {
            message in Button("OK", role: .cancel) {}
        } message: {
            message in Text(message)
        }
        .tint(Color.zorionPrimary)
    }
}

#Preview {
    CreateProfilePictureView()
}

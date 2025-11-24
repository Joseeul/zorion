//
//  ProfileView.swift
//  zorion
//
//  Created by Jose Andreas on 02/11/25.
//

import SwiftUI

struct ProfileView: View {
    @State private var user: UserModel? = nil
    @State private var isLoading: Bool = false
    @State private var isShowingAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    func fetchUser() async {
        isLoading = true
        
        do {
            user = try await fetchSingleUserData()
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
        VStack {
            if isLoading {
                ProgressView("Loading user data...")
            } else {
                AsyncImage(url: user?.profile_picture) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(.circle)
                        .frame(width: 70)
                } placeholder: {
                    Color.gray.opacity(0.3)
                        .frame(width: 70, height: 70)
                        .overlay(
                            ProgressView()
                                .tint(.gray)
                        )
                        .clipShape(.circle)
                }
                
                Text(user?.username ?? "userName")
                    .fontWeight(.semibold)
                    .padding(.vertical, 8)
                
                Text("Joined since \(user?.created_at.formatted(.dateTime.year()) ?? Date().formatted(.dateTime.year()))")
                    .font(.footnote)
                
                ScrollView {
                    Group {
                        Text("User Settings")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button(action: {}, label: {
                            Text("Change username")
                            
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
                            Text("Change profile picture")
                            
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
                            Text("I'm a content creator")
                            
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
                    }
                    
                    Group {
                        Text("Creator Settings")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button(action: {}, label: {
                            Text("Change room photo")
                            
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
                            Text("Change room name")
                            
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
                            Text("Change room description")
                            
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
                            Text("Manage room members")
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        })
                        .frame(maxWidth: .infinity)
                        .padding([.top, .bottom], 12)
                        .padding([.trailing, .leading], 8)
                        .background(.zorionSettings)
                        .foregroundStyle(.zorionGray)
                        .cornerRadius(8)
                    }
                    
                    Group {
                        Text("App Settings")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button(action: {}, label: {
                            Text("Theme")
                            
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
                    }
                    
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
            }
        }
        .padding()
        .alert(alertTitle, isPresented: $isShowingAlert, presenting: alertMessage) {
            message in Button("OK", role: .cancel) {}
        } message: {
            message in Text(message)
        }
        .tint(Color.zorionPrimary)
        .task {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                return
            }
            
            await fetchUser()
        }
    }
}

#Preview {
    ProfileView()
}

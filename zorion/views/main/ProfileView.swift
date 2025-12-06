//
//  ProfileView.swift
//  zorion
//
//  Created by Jose Andreas on 02/11/25.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case changeUsername
    case changeProfilePicture
    case contentCreator
    case changeRoomPhoto
    case changeRoomName
    case changeRoomDescription
    case manageRoomMembers
    case changeTheme
    
    var id: String {
        return String(describing: self)
    }
}

struct ProfileView: View {
    @State private var user: UserModel? = nil
    @State private var isLoading: Bool = false
    @State private var isShowingAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var activeSheet: ActiveSheet?
    @EnvironmentObject var tabBarManager: TabBarManager
    
    @State private var tempCreator: Bool = true
    
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
                        
                        Button(action: {
                            activeSheet = .changeUsername
                        }, label: {
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
                        
                        Button(action: {
                            activeSheet = .changeProfilePicture
                        }, label: {
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
                        
                        if tempCreator == false {
                        } else {
                            Button(action: {
                                activeSheet = .contentCreator
                            }, label: {
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
                    }
                    
                    if tempCreator == true {
                        Group {
                            Text("Creator Settings")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button(action: {
                                activeSheet = .changeRoomPhoto
                            }, label: {
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
                            
                            Button(action: {
                                activeSheet = .changeRoomName
                            }, label: {
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
                            
                            Button(action: {
                                activeSheet = .changeRoomDescription
                            }, label: {
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
                            
                            Button(action: {
                                activeSheet = .manageRoomMembers
                            }, label: {
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
                    }
                    
                    Group {
                        Text("App Settings")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button(action: {
                            activeSheet = .changeTheme
                        }, label: {
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
                        UserDefaults.standard.removeObject(forKey: "JWT")
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
        .onAppear {
            tabBarManager.isVisible = true
        }
        .tint(Color.zorionPrimary)
        .task {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                return
            }
            
            await fetchUser()
        }
        .sheet(item: $activeSheet) { item in
            Group {
                switch item {
                case .changeUsername:
                    ChangeUsernameView()
                    
                case .changeProfilePicture:
                    ChangeProfilePictureView()
                    
                case .contentCreator:
                    SubmitCreatorView()
                    
                case .changeRoomPhoto:
                    ChangeRoomPhotoView()
                    
                case .changeRoomName:
                    ChangeRoomNameView()
                    
                case .changeRoomDescription:
                    ChangeRoomDescriptionView()
                    
                case .manageRoomMembers:
                    ManageRoomMembersView()
                    
                case .changeTheme:
                    ChangeThemeView()
                }
            }
            .presentationDetents([.medium])
            .presentationBackground(.white)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(TabBarManager())
}

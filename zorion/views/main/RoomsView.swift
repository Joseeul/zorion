//
//  RoomsView.swift
//  zorion
//
//  Created by Jose Andreas on 02/11/25.
//

import SwiftUI

struct RoomsView: View {
    @State private var user: UserModel? = nil
    @State private var room: RoomModel? = nil
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
    
    func fetchUserRoom() async {
        isLoading = true
        
        do {
            room = try await fetchCreatorRoom()
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
                ProgressView("Loading user and room data...")
            } else {
                VStack(alignment: .leading) {
                    HStack {
                        AsyncImage(url: user?.profile_picture) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(.circle)
                                .frame(width: 42)
                        } placeholder: {
                            Color.gray.opacity(0.3)
                                .frame(width: 42, height: 42)
                                .overlay(ProgressView())
                                .clipShape(.circle)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Welcome back!")
                                .font(.subheadline)
                                .foregroundStyle(.zorionGray)
                                .fontWeight(.semibold)
                            
                            Text(user?.username ?? "userName")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if user?.content_creator == true {
                        Text("Your room")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top, 12)
                        
                        RoomHeader(
                            imageUrl: URL(string: room?.room_picture ?? ""),
                            roomName: room?.room_name,
                            roomDesc: room?.room_desc
                        )
                    }
                    
                    Text("Community room")
                        .font(.title2)
                        .fontWeight(.bold)
                    
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
        .task {
            await fetchUser()
            
            // jika content creator true maka load room creator tersebut
            if user?.content_creator == true {
                await fetchUserRoom()
            }
        }
    }
}

#Preview {
    RoomsView()
}

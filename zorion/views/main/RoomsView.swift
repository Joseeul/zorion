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
    
    var contentCreator: Bool = true
    
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
        NavigationStack {
            ScrollView {
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
                                    
                                    Text("userName")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if contentCreator == true {
                                Text("Your room")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.top, 12)
                                
                                NavigationLink(destination: DetailRoom()) {
                                    RoomHeader(
                                        imageUrl: URL(string: room?.room_picture ?? ""),
                                        roomName: "test",
                                        roomDesc: "description test"
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                            
                            Text("Community room")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            RoomHeader(
                                imageUrl: URL(string: room?.room_picture ?? ""),
                                roomName: "public room",
                                roomDesc: "public room description"
                            )
                            
                            RoomHeader(
                                imageUrl: URL(string: room?.room_picture ?? ""),
                                roomName: "public room",
                                roomDesc: "public room description"
                            )
                            
                            Spacer()
                        }
                        .padding()
                        .alert(alertTitle, isPresented: $isShowingAlert, presenting: alertMessage) {
                            message in Button("OK", role: .cancel) {}
                        } message: {
                            message in Text(message)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    RoomsView()
}

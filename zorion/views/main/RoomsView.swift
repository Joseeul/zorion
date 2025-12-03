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
    @State private var communityRoom: [RoomModel] = []
    @State private var isLoading: Bool = false
    @State private var isShowingAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var userId: UUID?
    @EnvironmentObject var tabBarManager: TabBarManager
    
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
    
    func fetchCommunityRoom() async {
        isLoading = true
        
        do {
            communityRoom = try await fetchUserCommunityRoom()
            await filterCommunityRoom()
            try await getValidJWT()
        } catch {
            isLoading = false
            self.alertTitle = "Oops.. There Is An Error"
            self.alertMessage = "\(error.localizedDescription)"
            self.isShowingAlert = true
            return
        }
        
        isLoading = false
    }
    
    func filterCommunityRoom() async {
        if communityRoom.isEmpty {
            return
        } else {
            communityRoom.removeAll(where: {$0.room_owner == UUID(uuidString: UserDefaults.standard.string(forKey: "userId")!)})
        }
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
                                        .overlay(
                                            ProgressView()
                                                .tint(.gray)
                                        )
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
                                
                                NavigationLink(destination: DetailRoom(roomId: room?.room_id ?? UUID())) {
                                    RoomHeader(
                                        imageUrl: URL(string: room?.room_picture ?? ""),
                                        roomName: room?.room_name,
                                        roomDesc: room?.room_desc
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                            
                            Text("Community room")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            if communityRoom.isEmpty {
                                Text("You don't have any community room yet.")
                                    .padding(.top, 2)
                            } else {
                                ForEach(0..<communityRoom.filter {
                                    $0.room_owner != UUID(uuidString: UserDefaults.standard.string(forKey: "userId")!)
                                }.count, id: \.self) { index in
                                    
                                    NavigationLink(destination: DetailRoom(roomId: communityRoom[index].room_id)) {
                                        RoomHeader(
                                            imageUrl: URL(string: communityRoom[index].room_picture),
                                            roomName: communityRoom[index].room_name,
                                            roomDesc: communityRoom[index].room_desc
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
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
            .onAppear {
                tabBarManager.isVisible = true
            }
        }
        .tint(Color.zorionPrimary)
        .task {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                return
            }
            
            await fetchUser()
            await fetchCommunityRoom()
            
            UserDefaults.standard.set(false, forKey: "isContentCreator")
            
            if user?.content_creator == true {
                await fetchUserRoom()
                
                UserDefaults.standard.set(true, forKey: "isContentCreator")
            }
        }
    }
}

#Preview {
    RoomsView()
        .environmentObject(TabBarManager())
}

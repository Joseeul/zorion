//
//  DetailRoom.swift
//  zorion
//
//  Created by Jose Andreas on 04/11/25.
//

import SwiftUI

struct DetailRoom: View {
    @State private var isJoin: Bool = false
    @State var roomId: UUID
    @State private var room: RoomModel? = nil
    @State private var roomMembers: [UserModel] = []
    @State private var isLoading: Bool = false
    @State private var isShowingAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @EnvironmentObject var tabBarManager: TabBarManager
    
    func fetchRoomData() async {
        isLoading = true
        
        do {
            room = try await fetchRoomDetail(roomId: roomId)
        } catch {
            isLoading = false
            self.alertTitle = "Oops.. There Is An Error"
            self.alertMessage = "\(error.localizedDescription)"
            self.isShowingAlert = true
            return
        }
        
        isLoading = false
    }
    
    func isUserJoin() async {
        isLoading = true
        
        do {
            isJoin = try await userJoinRoom(roomId: roomId)
        } catch {
            isLoading = false
            self.alertTitle = "Oops.. There Is An Error"
            self.alertMessage = "\(error.localizedDescription)"
            self.isShowingAlert = true
            return
        }
        
        isLoading = false
    }
    
    func fetchRoomMember() async {
        isLoading = true
        
        do {
            roomMembers = try await fetchAllRoomMember(roomId: roomId)
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
            if isLoading {
                ProgressView("Loading room data...")
            } else {
                HStack {
                    AsyncImage(url: URL(string: room?.room_picture ?? "")) { image in
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
                        Text(room?.room_name ?? "roomName")
                            .fontWeight(.semibold)
                        
                        Text(room?.room_desc ?? "roomDesc")
                            .font(.footnote)
                            .foregroundStyle(.zorionGray)
                        
                    }
                }
                .padding(.bottom, 8)
                
                if isJoin == false {
                    Button(action: {
                        Task {
                            try await insertRoomMember(roomId: roomId)
                            await isUserJoin()
                        }
                    }, label: {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Join this room")
                                .frame(maxWidth: .infinity)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                    })
                    .frame(maxWidth: .infinity)
                    .padding([.top, .bottom], 12)
                    .padding([.trailing, .leading], 8)
                    .fontWeight(.semibold)
                    .background(.zorionPrimary)
                    .foregroundStyle(.white)
                    .cornerRadius(8)
                    
                    Text("Room participants")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 6)
                    
                    ScrollView {
                        ForEach(0..<roomMembers.count, id: \.self) { index in
                            HStack {
                                AsyncImage(url: roomMembers[index].profile_picture) { image in
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
                                
                                Text(roomMembers[index].username)
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                } else {
                    NavigationLink(destination: VoteView()) {
                        HStack {
                            Text("Vote")
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding([.top, .bottom], 12)
                    .padding([.trailing, .leading], 8)
                    .background(.zorionSettings)
                    .foregroundStyle(.zorionGray)
                    .cornerRadius(8)
                    .padding(.top, 8)
                    .buttonStyle(.plain)
                    
                    NavigationLink(destination: ChatView()) {
                        HStack {
                            Text("Chats")
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding([.top, .bottom], 12)
                    .padding([.trailing, .leading], 8)
                    .background(.zorionSettings)
                    .foregroundStyle(.zorionGray)
                    .cornerRadius(8)
                    .padding(.top, 8)
                    .buttonStyle(.plain)
                    
                    NavigationLink(destination: ChatView()) {
                        HStack {
                            Text("Voice & video")
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding([.top, .bottom], 12)
                    .padding([.trailing, .leading], 8)
                    .background(.zorionSettings)
                    .foregroundStyle(.zorionGray)
                    .cornerRadius(8)
                    .padding(.top, 8)
                    .buttonStyle(.plain)
                }
                
                Spacer()
            }
        }
        .padding()
        .alert(alertTitle, isPresented: $isShowingAlert, presenting: alertMessage) {
            message in Button("OK", role: .cancel) {}
        } message: {
            message in Text(message)
        }
        .onAppear {
            tabBarManager.isVisible = false
        }
        .tint(Color.zorionPrimary)
        .task {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                isJoin = true
                return
            }
            
            await fetchRoomData()
            await isUserJoin()
            
            if isJoin == false {
                await fetchRoomMember()
            }
        }
    }
}

#Preview {
    DetailRoom(roomId: UUID())
        .environmentObject(TabBarManager())
}

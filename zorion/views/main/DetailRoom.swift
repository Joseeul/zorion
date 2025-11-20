//
//  DetailRoom.swift
//  zorion
//
//  Created by Jose Andreas on 04/11/25.
//

import SwiftUI

struct DetailRoom: View {
    @State private var isJoin: Bool = true
    @State var roomId: UUID
    @State private var room: RoomModel? = nil
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
    
    var body: some View {
        VStack(alignment: .leading) {
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
                Button(action: {}, label: {
                    Text("Join this room")
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
                
                Text("Room participants")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 6)
                
                HStack {
                    Image("profile_blue")
                        .resizable()
                        .scaledToFit()
                        .clipShape(.circle)
                        .frame(width: 42)
                    
                    Text("userName")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Button(action: {}, label: {
                    Text("Vote")
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                })
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom], 12)
                .padding([.trailing, .leading], 8)
                .background(.zorionSettings)
                .foregroundStyle(.zorionGray)
                .cornerRadius(8)
                .padding(.top, 8)
                
                Button(action: {}, label: {
                    Text("Chats")
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                })
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom], 12)
                .padding([.trailing, .leading], 8)
                .background(.zorionSettings)
                .foregroundStyle(.zorionGray)
                .cornerRadius(8)
                .padding(.top, 8)
                
                Button(action: {}, label: {
                    Text("Voice & video")
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                })
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom], 12)
                .padding([.trailing, .leading], 8)
                .background(.zorionSettings)
                .foregroundStyle(.zorionGray)
                .cornerRadius(8)
                .padding(.top, 8)
            }
            
            Spacer()
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
        .onDisappear {
            tabBarManager.isVisible = true
        }
        .task {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                return
            }
            
            await fetchRoomData()
        }
    }
}

#Preview {
    DetailRoom(roomId: UUID())
        .environmentObject(TabBarManager())
}

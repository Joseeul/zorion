//
//  ManageRoomMembersView.swift
//  zorion
//
//  Created by Jose on 05/12/25.
//

import SwiftUI

struct ManageRoomMembersView: View {
    @State private var searchedMember: String = ""
    @State private var roomMembers: [UserModel] = []
    @State private var isLoading: Bool = false
    @State private var isShowingAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    func fetchRoomMember() async {
        isLoading = true
        
        let roomId: UUID = UUID(uuidString: UserDefaults.standard.value(forKey: "userRoomId") as! String)!
        
        do {
            roomMembers = try await fetchOtherMember(roomId: roomId)
        } catch {
            isLoading = false
            self.alertTitle = "Oops.. There Is An Error"
            self.alertMessage = "\(error.localizedDescription)"
            self.isShowingAlert = true
            return
        }
        
        isLoading = false
    }
    
    func handleDeleteMember(userId: UUID) async {
        let roomId: UUID = UUID(uuidString: UserDefaults.standard.value(forKey: "userRoomId") as! String)!
        
        do {
            try await deleteMember(userId: userId, roomId: roomId)
        } catch {
            isLoading = false
            self.alertTitle = "Oops.. There Is An Error"
            self.alertMessage = "\(error.localizedDescription)"
            self.isShowingAlert = true
            return
        }
    }
    
    var body: some View {
        VStack {
            Text("Remove a member")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 8)
            
            HStack {
                TextField(
                    "Search...",
                    text: $searchedMember
                )
                .padding(.vertical, 12)
                .padding(.horizontal, 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            Color.zorionGray,
                            lineWidth: 0.5
                        )
                )
                
                Button(action: {}, label: {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 16, height: 16)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                })
                .padding(14)
                .background(.zorionPrimary)
                .clipShape(Circle())
            }
            .padding(.bottom, 12)
            
            if isLoading {
                ProgressView("Loading members data...")
            } else {
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
                            
                            Spacer()
                            
                            Button(action: {
                                Task {
                                    await handleDeleteMember(userId: roomMembers[index].user_id)
                                    await fetchRoomMember()
                                }
                            }, label: {
                                Image(systemName: "person.fill.badge.minus")
                                    .font(.system(size: 18))
                                    .padding()
                                    .foregroundStyle(.red)
                            })
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .padding(.top, 30)
        .padding()
        .alert(alertTitle, isPresented: $isShowingAlert, presenting: alertMessage) {
            message in Button("OK", role: .cancel) {}
        } message: {
            message in Text(message)
        }
        .tint(.zorionPrimary)
        .task {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                return
            }
            
            await fetchRoomMember()
        }
    }
}

#Preview {
    ManageRoomMembersView()
}

//
//  DiscoverView.swift
//  zorion
//
//  Created by Jose Andreas on 02/11/25.
//

import SwiftUI

struct DiscoverView: View {
    @State private var searchQuery: String = ""
    @State private var isLoading: Bool = false
    @State private var isShowingAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var rooms: [RoomModel] = []
    
    func fetchData() async {
        isLoading = true
        
        do {
            rooms = try await fetchAllRoom()
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
                if isLoading {
                    ProgressView("Loading popular rooms data...")
                } else {
                    VStack(alignment: .leading) {
                        HStack {
                            TextField(
                                "Search...",
                                text: $searchQuery
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
                                    .clipShape(.circle)
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                            })
                            .padding(14)
                            .background(.zorionPrimary)
                            .clipShape(Circle())
                        }
                        
                        Text("Discover popular rooms")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top, 12)
                        
                        ForEach(0..<rooms.count, id: \.self) { index in
                            NavigationLink(destination: DetailRoom(roomId: rooms[index].room_id)) {
                                RoomHeader(
                                    imageUrl: URL(string: rooms[index].room_picture),
                                    roomName: rooms[index].room_name,
                                    roomDesc: rooms[index].room_desc
                                )
                            }
                            .buttonStyle(.plain)}
                    }
                    .padding()
                    .alert(alertTitle, isPresented: $isShowingAlert, presenting: alertMessage) {
                        message in Button("OK", role: .cancel) {}
                    } message: {
                        message in Text(message)
                    }
                    .onTapGesture {
                        hideKeyboard()
                    }
                }
            }
        }
        .tint(Color.zorionPrimary)
        .task {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                return
            }
            
            await fetchData()
        }
    }
}

#Preview {
    DiscoverView()
}

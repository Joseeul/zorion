//
//  ChatView.swift
//  zorion
//
//  Created by Jose on 25/11/25.
//

import SwiftUI

struct ChatView: View {
    @State private var messageContent: String = ""
    @State private var chatData: [MessageModel] = []
    @State private var user: UserModel? = nil
    @State private var isLoading: Bool = false
    @EnvironmentObject var tabBarManager: TabBarManager
    
    var body: some View {
        VStack(alignment: .leading) {
            if isLoading {
                ProgressView("Loading chats data...")
            } else {
                Text("Chats")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Divider()
                
                ScrollView {
                    ForEach(0..<20) { index in
                        HStack(alignment: .bottom) {
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
                                HStack {
                                    Text(user?.username ?? "userName")
                                        .fontWeight(.semibold)
                                    
                                    Text("at dd/mm/yy, 8:00 AM")
                                        .font(.caption)
                                        .foregroundStyle(.zorionGray)
                                        .fontWeight(.light)
                                }
                                
                                Text(user?.username ?? "Placeholder text message...")
                                    .font(.subheadline)
                            }
                        }
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .defaultScrollAnchor(.bottom)
                
                Spacer()
                
                HStack {
                    TextField(
                        "Type here...",
                        text: $messageContent
                    )
                    .padding(.vertical, 12)
                    .padding(.horizontal, 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(
                                Color.zorionGray,
                                lineWidth: 0.5
                            )
                    )
                    
                    Button(action: {}, label: {
                        Image(systemName: "paperclip")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 16, height: 16)
                            .foregroundColor(.zorionGray)
                            .fontWeight(.semibold)
                    })
                    .padding(14)
                    .background(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(
                                Color.zorionGray,
                                lineWidth: 0.5
                            )
                    )
                    
                    Button(action: {}, label: {
                        Image(systemName: "paperplane.fill")
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
                .background(Color.white)
            }
        }
        .padding()
        .onAppear {
            tabBarManager.isVisible = false
        }
        .task {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                return
            }
        }
    }
}

#Preview {
    ChatView()
        .environmentObject(TabBarManager())
}

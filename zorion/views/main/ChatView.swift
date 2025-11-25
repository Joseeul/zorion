//
//  ChatView.swift
//  zorion
//
//  Created by Jose on 25/11/25.
//

import SwiftUI

struct ChatView: View {
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
                            HStack {
                                Text(user?.username ?? "userName")
                                    .fontWeight(.semibold)
                                
                                Text("at dd/mm/yy, 8:00 AM")
                                    .font(.subheadline)
                                    .foregroundStyle(.zorionGray)
                                    .fontWeight(.semibold)
                            }
                            
                            Text(user?.username ?? "Placeholder text message...")
                                .font(.subheadline)
                        }
                    }
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
            }
        }
        .padding()
        .onAppear {
            tabBarManager.isVisible = false
        }
    }
}

#Preview {
    ChatView()
        .environmentObject(TabBarManager())
}

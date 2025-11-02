//
//  MainView.swift
//  zorion
//
//  Created by Jose Andreas on 02/11/25.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab: TabItem = .rooms
    
    enum TabItem: String, CaseIterable {
        case discover = "Discover"
        case rooms = "Rooms"
        case profile = "Profile"
        
        var iconName: String {
            switch self {
            case .discover: return "safari.fill"
            case .rooms: return "bubble.left.and.text.bubble.right.fill"
            case .profile: return "person.crop.circle.fill"
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .discover:
                    DiscoverView()
                case .rooms:
                    RoomsView()
                case .profile:
                    ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack(spacing: 0) {
                ForEach(TabItem.allCases, id: \.self) { item in
                    TabButton(selectedTab: $selectedTab, item: item)
                }
            }
            .frame(height: 70)
            .background(Color.white)
            .overlay(
                Rectangle()
                    .frame(height: 0.2)
                    .foregroundColor(.zorionGray.opacity(0.4)),
                alignment: .top
            )
            
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .statusBarHidden(false)
    }
}

struct TabButton: View {
    @Binding var selectedTab: MainView.TabItem
    let item: MainView.TabItem
    
    let activeColor: Color = Color(.zorionPrimary)
    let inactiveColor: Color = .zorionGray
    
    var body: some View {
        Button(action: {
            selectedTab = item
        }) {
            VStack(spacing: 5) {
                Image(systemName: item.iconName)
                    .font(.title2)
                Text(item.rawValue)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(selectedTab == item ? activeColor : inactiveColor)
        }
    }
}

#Preview {
    MainView()
}

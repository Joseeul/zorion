//
//  VoteView.swift
//  zorion
//
//  Created by Jose on 25/11/25.
//

import SwiftUI

struct VoteView: View {
    @State private var isLoading: Bool = false
    @EnvironmentObject var tabBarManager: TabBarManager
    
    var body: some View {
        VStack(alignment: .leading) {
            if isLoading {
                ProgressView("Loading votes data...")
            } else {
                Text("Vote")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Divider()
                
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
    VoteView()
        .environmentObject(TabBarManager())
}

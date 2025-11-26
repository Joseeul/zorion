//
//  VoteView.swift
//  zorion
//
//  Created by Jose on 25/11/25.
//

import SwiftUI

struct VoteView: View {
    @State private var inputedQuestion: String = ""
    @State private var isLoading: Bool = false
    @State private var startColor: Color = .random
    @State private var endColor: Color = .random
    @State private var showCreateVote: Bool = false
    @EnvironmentObject var tabBarManager: TabBarManager
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading) {
                if isLoading {
                    ProgressView("Loading votes data...")
                } else {
                    Text("Vote")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Divider()
                        .padding(.bottom, 8)
                    
                    ScrollView {
                        VStack(alignment: .leading) {
                            Text("Vote Title")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.bottom, 4)
                                .shadow(radius: 3)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [startColor, endColor]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    }
                    
                    Spacer()
                }
            }
            
            if !isLoading {
                Button(action: {
                    showCreateVote = true
                }) {
                    Image(systemName: "plus")
                        .font(.title3
                            .weight(.semibold)
                        )
                        .foregroundColor(.white)
                        .padding()
                        .background(.zorionPrimary)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.3), radius: 4, x: 2, y: 4)
                }
            }
        }
        .padding()
        .sheet(isPresented: $showCreateVote) {
            VStack(alignment: .leading){
                Text("Insert a new vote")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.vertical, 8)
                
                TextField(
                    "Question",
                    text: $inputedQuestion
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
                .padding(.bottom, 8)
                .disableAutocorrection(true)
                
                Button(action: {}, label: {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                })
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom], 12)
                .padding([.trailing, .leading], 8)
                .fontWeight(.semibold)
                .background(Color.zorionPrimary)
                .foregroundStyle(.white)
                .cornerRadius(8)
                
                Spacer()
            }
            .padding()
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        .onAppear {
            tabBarManager.isVisible = false
        }
    }
}

extension Color {
    static var random: Color {
        return Color(
            hue: .random(in: 0...1),
            saturation: .random(in: 0.6...1),
            brightness: .random(in: 0.5...0.8)
        )
    }
}

#Preview {
    VoteView()
        .environmentObject(TabBarManager())
}

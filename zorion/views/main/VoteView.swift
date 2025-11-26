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
    @State private var showCreateVote: Bool = false
    @EnvironmentObject var tabBarManager: TabBarManager
    @State private var options: [VoteOption] = [
        VoteOption(),
        VoteOption()
    ]
    
    func addOption() {
        options.append(VoteOption())
    }
    
    func deleteOption(id: UUID) {
        options.removeAll { $0.id == id }
    }
    
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
                        ForEach(0..<10) { index in
                            VoteCard()
                                .padding(.bottom, 8)
                        }
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
                
                Divider()
                    .padding(.vertical, 4)
                
                ScrollView {
                    ForEach($options) { $option in
                        HStack(alignment: .center) {
                            TextField(
                                "Option...",
                                text: $option.text
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
                            .disableAutocorrection(true)
                            
                            if options.count > 2 {
                                Button(action: {
                                    deleteOption(id: option.id)
                                }, label: {
                                    Image(systemName: "trash.fill")
                                        .padding(.vertical, 12)
                                        .padding(.horizontal, 8)
                                })
                                .background(Color.red)
                                .foregroundStyle(.white)
                                .cornerRadius(8)
                            }
                        }
                        .padding(.bottom, 8)
                    }
                }
                
                Button(action: {
                    addOption()
                }, label: {
                    HStack {
                        Image(systemName: "plus")
                            .foregroundStyle(.black)
                        
                        Text("Add new option")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                })
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom], 12)
                .padding([.trailing, .leading], 8)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.zorionGray, lineWidth: 0.5)
                )
                .padding(.bottom, 8)
                
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
            .background(.white)
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        .onAppear {
            tabBarManager.isVisible = false
        }
    }
}

#Preview {
    VoteView()
        .environmentObject(TabBarManager())
}

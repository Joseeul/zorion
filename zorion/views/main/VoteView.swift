//
//  VoteView.swift
//  zorion
//
//  Created by Jose on 25/11/25.
//

import SwiftUI

struct VoteView: View {
    @State var roomId: UUID
    @State private var inputedQuestion: String = ""
    @State private var isLoading: Bool = false
    @State private var showCreateVote: Bool = false
    @State private var isShowingAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var contentCreator: Bool = UserDefaults.standard.bool(forKey: "isContentCreator")
    @State private var showVoteButton: Bool = false
    @State private var voteData: [VoteModel] = []
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
    
    func handleInsertVote() async {
        do {
            try await insertVote(roomId: roomId, question: inputedQuestion, choices: options)
            
            await fetchVoteData()
            
            inputedQuestion = ""
            showCreateVote = false
        } catch {
            self.alertTitle = "Oops.. There Is An Error"
            self.alertMessage = "\(error.localizedDescription)"
            self.isShowingAlert = true
            return
        }
    }
    
    func fetchVoteData() async {
        isLoading = true
        
        do {
            voteData = try await fetchVote(roomId: roomId)
        } catch {
            isLoading = false
            self.alertTitle = "Oops.. There Is An Error"
            self.alertMessage = "\(error.localizedDescription)"
            self.isShowingAlert = true
            return
        }
        
        isLoading = false
    }
    
    func checkCreatorVote() async {
        isLoading = true
        
        do {
            showVoteButton = try await checkIsCreatorRoom(roomId: roomId)
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
                        ForEach(voteData) { vote in
                            VoteCard(
                                voteId: vote.vote_id,
                                question: vote.question,
                                choices: vote.vote_choices,
                                onVoteSuccess: {
                                    await fetchVoteData()
                                }
                            )
                            .padding(.bottom, 8)
                        }
                    }
                    
                    Spacer()
                }
            }
            
            if !isLoading && showVoteButton {
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
                
                Button(action: {
                    Task {
                        await handleInsertVote()
                    }
                }, label: {
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
        .alert(alertTitle, isPresented: $isShowingAlert, presenting: alertMessage) {
            message in Button("OK", role: .cancel) {}
        } message: {
            message in Text(message)
        }
        .onAppear {
            tabBarManager.isVisible = false
        }
        .task {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                return
            }
            
            await fetchVoteData()
            
            if contentCreator {
                await checkCreatorVote()
            }
        }
    }
}

#Preview {
    VoteView(roomId: UUID())
        .environmentObject(TabBarManager())
}

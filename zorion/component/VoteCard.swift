//
//  VoteCard.swift
//  zorion
//
//  Created by Jose on 26/11/25.
//

import SwiftUI

struct VoteCard: View {
    let voteId: UUID
    let question: String
    let choices: [VoteChoiceModel]
    var onVoteSuccess: () async -> Void
    @State private var isShowingAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    func handleVote(voteId: UUID, choiceId: UUID) async {
        do {
            try await inputVote(voteId: voteId, choiceId: choiceId)
            
            self.alertTitle = "Vote Successfully"
            self.alertMessage = "Your vote has been successfully submitted. Thank you!"
            self.isShowingAlert = true
        } catch {
            self.alertTitle = "Oops.. There Is An Error"
            self.alertMessage = "\(error.localizedDescription)"
            self.isShowingAlert = true
            return
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(question)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom, 4)
            
            ForEach(choices) { option in
                Button(action: {
                    Task {
                        await handleVote(voteId: option.vote_id, choiceId: option.choice_id)
                    }
                }, label: {
                    HStack {
                        Text(option.choice)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("\(option.totalVotes)")
                            .font(
                                .system(
                                    .body,
                                    design: .monospaced
                                )
                            )
                            .foregroundColor(.secondary)
                    }
                })
                .padding([.top, .bottom], 12)
                .padding([.trailing, .leading], 8)
                .fontWeight(.semibold)
                .background(.white)
                .foregroundStyle(.black)
                .cornerRadius(8)
                .padding(.bottom, 4)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .systemGray6))
        .cornerRadius(8)
        .alert(alertTitle, isPresented: $isShowingAlert, presenting: alertMessage) {
            message in Button("OK", role: .cancel) {
                Task {
                    await onVoteSuccess()
                }
            }
        } message: {
            message in Text(message)
        }
    }
}

//
//  VoteCard.swift
//  zorion
//
//  Created by Jose on 26/11/25.
//

import SwiftUI

struct VoteCard: View {
    let question: String
    let choiceOptionCount: Int
    let choice: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(question)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom, 4)
            
            ForEach(0..<choiceOptionCount, id: \.self) { index in
                Button(action: {}, label: {
                    HStack {
                        Text(choice)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("54")
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
    }
}

#Preview {
    VoteCard(question: "Demo Question", choiceOptionCount: 2, choice: "Vote choice option")
}

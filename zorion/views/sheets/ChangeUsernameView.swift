//
//  ChangeUsernameView.swift
//  zorion
//
//  Created by Jose on 05/12/25.
//

import SwiftUI

struct ChangeUsernameView: View {
    @State private var inputedUsername: String = ""
    
    var body: some View {
        VStack {
            TextField(
                "Username",
                text: $inputedUsername
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
            
            Button(action: {}, label: {
                Text("Change username")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            })
            .frame(maxWidth: .infinity)
            .padding([.top, .bottom], 12)
            .padding([.trailing, .leading], 8)
            .fontWeight(.semibold)
            .background(.zorionPrimary)
            .foregroundStyle(.white)
            .cornerRadius(8)
            
            Spacer()
        }
        .padding(.top, 30)
        .padding()
    }
}

#Preview {
    ChangeUsernameView()
}

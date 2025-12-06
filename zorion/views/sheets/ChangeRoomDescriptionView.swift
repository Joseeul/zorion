//
//  ChangeRoomDescriptionView.swift
//  zorion
//
//  Created by Jose on 05/12/25.
//

import SwiftUI

struct ChangeRoomDescriptionView: View {
    @State private var inputedRoomDescription: String = ""
    @State private var isShowingAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @Environment(\.dismiss) var dismiss
    
    func handleRoomDescUpdate() async {
        if inputedRoomDescription.isEmpty {
            self.alertTitle = "Missing Input"
            self.alertMessage = "Please fill all the field."
            self.isShowingAlert = true
            return
        }
        
        if inputedRoomDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.alertTitle = "Missing Input"
            self.alertMessage = "Please fill all the field."
            self.isShowingAlert = true
            return
        }
        
        do {
            try await roomDescriptionUpdate(newDescription: inputedRoomDescription)
            
            inputedRoomDescription = ""
            
            dismiss()
        } catch {
            self.alertTitle = "Oops.. There Is An Error"
            self.alertMessage = "\(error.localizedDescription)"
            self.isShowingAlert = true
            return
        }
    }
    
    var body: some View {
        VStack {
            Text("Change room description")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 8)
            
            TextField(
                "Room description",
                text: $inputedRoomDescription
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
            
            Button(action: {
                Task {
                    await handleRoomDescUpdate()
                }
            }, label: {
                Text("Change room description")
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
        .alert(alertTitle, isPresented: $isShowingAlert, presenting: alertMessage) {
            message in Button("OK", role: .cancel) {}
        } message: {
            message in Text(message)
        }
    }
}

#Preview {
    ChangeRoomDescriptionView()
}

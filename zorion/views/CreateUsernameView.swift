//
//  CreateUsernameView.swift
//  zorion
//
//  Created by Jose Andreas on 13/10/25.
//

import SwiftUI

struct CreateUsernameView: View {
    @Binding var path: NavigationPath
    @State private var inputedUsername: String = ""
    @State private var isShowingAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    func handleUserName() {
        if inputedUsername.isEmpty {
            self.alertTitle = "Missing Input"
            self.alertMessage = "Please fill all the field."
            self.isShowingAlert = true
            return
        }
        
        if inputedUsername.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.alertTitle = "Missing Input"
            self.alertMessage = "Please fill all the field."
            self.isShowingAlert = true
            return
        }
        
        UserDefaults.standard.set(inputedUsername, forKey: "userUsername")
        
        path.append(authRoute.CreateProfilePictureView)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("What should")
                .font(.largeTitle)
                .fontWeight(.bold)
            + Text(" we call you?")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.zorionPrimary)
            
            Text("Enter a display name so your friends can recognize you easily.")
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 8)
            
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
            .padding(.top, 8)
            .disableAutocorrection(true)
            
            Button(action: {
                handleUserName()
            }, label: {
                Text("Submit")
                    .frame(maxWidth: .infinity)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            })
            .frame(maxWidth: .infinity)
            .padding([.top, .bottom], 12)
            .padding([.trailing, .leading], 8)
            .background(Color.zorionPrimary)
            .foregroundStyle(.white)
            .cornerRadius(8)
            .padding(.top, 8)
            
            Spacer()
        }
        .onTapGesture {
            hideKeyboard()
        }
        .alert(alertTitle, isPresented: $isShowingAlert, presenting: alertMessage) {
            message in Button("OK", role: .cancel) {}
        } message: {
            message in Text(message)
        }
        .padding()
        .tint(Color.zorionPrimary)
    }
}

#Preview {
    CreateUsernameView(path: .constant(NavigationPath()))
}

//
//  AccountValidationView.swift
//  zorion
//
//  Created by Jose Andreas on 13/10/25.
//

import SwiftUI

struct AccountValidationView: View {
    let platform: String
    @Binding var path: NavigationPath
    @State private var inputedName: String = ""
    @State private var isShowingAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var creatorData: CreatorVerifyData?
    
    func handleValidation() async {
        if inputedName.isEmpty {
            self.alertTitle = "Missing Input"
            self.alertMessage = "Please fill all the field."
            self.isShowingAlert = true
            return
        }
        
        if inputedName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.alertTitle = "Missing Input"
            self.alertMessage = "Please fill all the field."
            self.isShowingAlert = true
            return
        }
        
        do {
            creatorData = try await checkCreatorVerify(platform: platform, username: inputedName)
        } catch {
            print(error.localizedDescription)
        }
        
        if creatorData?.followers ?? 0 >= 1000 {
            UserDefaults.standard.set(true, forKey: "isContentCreator")
            path.append(authRoute.CreateCreatorRoomView)
        } else {
            self.alertTitle = "You don't currently meet the qualifications"
            self.alertMessage = "Switch to another platform or register as a non-content creator."
            self.isShowingAlert = true
            return
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Let's validate your")
                .font(.largeTitle)
                .fontWeight(.bold)
            + Text(" \(platform) account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.zorionPrimary)
            
            TextField(
                "Name",
                text: $inputedName
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
                Task {
                    await handleValidation()
                }
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
            
            Text("*If you're a content creator, you'll need to validate your account first. If verification is successful, you'll automatically receive a content creator room and a content creator badge. Please note that to earn the content creator badge or creator room, you must have at least 1,000 followers/subscribers on the platform you're validating.")
                .font(.subheadline)
                .italic()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)
            
            Spacer()
        }
        .alert(alertTitle, isPresented: $isShowingAlert, presenting: alertMessage) {
            message in Button("OK", role: .cancel) {}
        } message: {
            message in Text(message)
        }
        .onTapGesture {
            hideKeyboard()
        }
        .padding()
        .tint(Color.zorionPrimary)
    }
}

#Preview {
    AccountValidationView(platform: "AppName", path: .constant(NavigationPath()))
}

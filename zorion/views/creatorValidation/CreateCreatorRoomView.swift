//
//  CreateCreatorRoom.swift
//  zorion
//
//  Created by Jose Andreas on 13/10/25.
//

import SwiftUI

struct CreateCreatorRoomView: View {
    @Binding var path: NavigationPath
    @State private var inputedRoomName: String = ""
    @State private var inputedRoomDesc: String = ""
    @State private var isShowingAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var selectedRoomPicture: String = ""
    
    func handleCreateRoom() {
        if inputedRoomName.isEmpty || inputedRoomDesc.isEmpty {
            self.alertTitle = "Missing Input"
            self.alertMessage = "Please fill all the field."
            self.isShowingAlert = true
            return
        }
        
        if inputedRoomName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || inputedRoomDesc.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.alertTitle = "Missing Input"
            self.alertMessage = "Please fill all the field."
            self.isShowingAlert = true
            return
        }
        
        if selectedRoomPicture.isEmpty {
            self.alertTitle = "Missing Input"
            self.alertMessage = "Please choose a room picture."
            self.isShowingAlert = true
            return
        }
        
        UserDefaults.standard.set(inputedRoomName, forKey: "roomName")
        UserDefaults.standard.set(inputedRoomDesc, forKey: "roomDesc")
        UserDefaults.standard.set(selectedRoomPicture, forKey: "userRoomPicture")
        
        path.append(authRoute.CreateUsernameView)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Let's set up your")
                .font(.largeTitle)
                .fontWeight(.bold)
            + Text(" own room!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.zorionPrimary)
            
            Text("Room name")
                .font(.subheadline)
                .padding(.top, 8)
            
            TextField(
                "Enter your room name",
                text: $inputedRoomName
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
            .padding(.top, 4)
            .disableAutocorrection(true)
            
            Text("Room description")
                .font(.subheadline)
                .padding(.top, 8)
            
            TextField(
                "Enter your room description",
                text: $inputedRoomDesc
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
            .padding(.top, 4)
            .disableAutocorrection(true)
            
            Text("\(inputedRoomDesc.count)/30 characters")
                .font(.caption2)
                .foregroundColor(.zorionGray)
                .padding(.top, 4)
            
            Text("Room picture")
                .font(.subheadline)
                .padding(.top, 8)
            
            VStack {
                HStack(spacing: 24) {
                    Button(action: {
                        self.alertTitle = "You can't do this now"
                        self.alertMessage = "Please change your custom image via profile after your account is successfully created."
                        self.isShowingAlert = true
                    }, label: {
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 32, height: 32)
                            .clipShape(.circle)
                            .foregroundColor(.zorionGray)
                    })
                    .padding(14)
                    .overlay(
                        Circle()
                            .stroke(.zorionGray, lineWidth: 0.5)
                    )
                    
                    Button(action: {
                        selectedRoomPicture = "chat_orange"
                    }, label: {
                        Image("chat_orange")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(.circle)
                    })
                    .padding(2)
                    .overlay(
                        Circle()
                            .stroke(.zorionGray, lineWidth: 1)
                    )
                    
                    Button(action: {
                        selectedRoomPicture = "chat_black"
                    }, label: {
                        Image("chat_black")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(.circle)
                    })
                    .padding(2)
                    .overlay(
                        Circle()
                            .stroke(.zorionGray, lineWidth: 1)
                    )
                    
                    
                    Button(action: {
                        selectedRoomPicture = "chat_red"
                    }, label: {
                        Image("chat_red")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(.circle)
                    })
                    .padding(2)
                    .overlay(
                        Circle()
                            .stroke(.zorionGray, lineWidth: 1)
                    )
                }
                
                HStack(spacing: 24) {
                    Button(action: {
                        selectedRoomPicture = "chat_green"
                    }, label: {
                        Image("chat_green")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(.circle)
                    })
                    .padding(2)
                    .overlay(
                        Circle()
                            .stroke(.zorionGray, lineWidth: 1)
                    )
                    
                    Button(action: {
                        selectedRoomPicture = "chat_blue"
                    }, label: {
                        Image("chat_blue")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(.circle)
                    })
                    .padding(2)
                    .overlay(
                        Circle()
                            .stroke(.zorionGray, lineWidth: 1)
                    )
                    
                    Button(action: {
                        selectedRoomPicture = "chat_pink"
                    }, label: {
                        Image("chat_pink")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(.circle)
                    })
                    .padding(2)
                    .overlay(
                        Circle()
                            .stroke(.zorionGray, lineWidth: 1)
                    )
                    
                    
                    Button(action: {
                        selectedRoomPicture = "chat_dark_blue"
                    }, label: {
                        Image("chat_dark_blue")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(.circle)
                    })
                    .padding(2)
                    .overlay(
                        Circle()
                            .stroke(.zorionGray, lineWidth: 1)
                    )
                }
                .padding(.top, 8)
            }
            
            Text("Image selected: \(selectedRoomPicture)")
                .padding(.top, 8)
            
            Button(action: {
                handleCreateRoom()
            }, label: {
                Text("Create room")
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
            .padding(.top, 16)
            
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
    CreateCreatorRoomView(path: .constant(NavigationPath()))
}

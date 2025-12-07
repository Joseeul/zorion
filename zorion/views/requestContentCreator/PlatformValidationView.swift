//
//  PlatformValidationView.swift
//  zorion
//
//  Created by Jose on 06/12/25.
//

import SwiftUI

struct PlatformValidationView: View {
    @State var plaform: String
    @State private var inputedRoomName: String = ""
    @State private var inputedRoomDesc: String = ""
    @State private var inputedName: String = ""
    @State private var isShowingAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var creatorData: CreatorVerifyData?
    @State private var selectedRoomPicture: String = ""
    @State private var isContentCreator: Bool = false
    @Environment(\.dismiss) var dismiss
    
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
            creatorData = try await checkCreatorVerify(platform: plaform, username: inputedName)
        } catch {
            print(error.localizedDescription)
        }
        
        if creatorData?.followers ?? 0 >= 1000 {
            isContentCreator = true
            self.alertTitle = "You are now qualified as a content creator"
            self.alertMessage = "Please fill in the details below to create your room."
            self.isShowingAlert = true
        } else {
            isContentCreator = false
            self.alertTitle = "You don't currently meet the qualifications"
            self.alertMessage = "Switch to another platform or register as a non-content creator."
            self.isShowingAlert = true
        }
    }
    
    func handleCreateRoom() async {
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
        
        do {
            try await addNewCreator(roomName: inputedRoomName, roomDesc: inputedRoomDesc, roomPicture: selectedRoomPicture)
            
            UserDefaults.standard.set(true, forKey: "updatedContentCreator")
            
            dismiss()
        } catch {
            self.alertTitle = "Oops.. There Is An Error"
            self.alertMessage = "\(error.localizedDescription)"
            self.isShowingAlert = true
            return
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Verification platform: \(plaform)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 8)
                
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
                
                VStack(alignment: .leading) {
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
                            Button(action: {}, label: {
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
                        Task {
                            await handleCreateRoom()
                        }
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
                }
            }
        }
        .padding()
        .alert(alertTitle, isPresented: $isShowingAlert, presenting: alertMessage) {
            message in Button("OK", role: .cancel) {}
        } message: {
            message in Text(message)
        }
    }
}

#Preview {
    PlatformValidationView(plaform: "PlatformName")
}

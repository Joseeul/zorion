//
//  ChangeRoomPhotoView.swift
//  zorion
//
//  Created by Jose on 05/12/25.
//

import SwiftUI

struct ChangeRoomPhotoView: View {
    @State private var selectedRoomPicture: String = ""
    @State private var isShowingAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @Environment(\.dismiss) var dismiss
    
    func handleRoomPhotoUpdate() async {
        do {
            try await roomPictureUpdate(newPicture: selectedRoomPicture)
            
            dismiss()
        } catch {
            self.alertTitle = "Oops.. There Is An Error"
            self.alertMessage = "\(error.localizedDescription)"
            self.isShowingAlert = true
            return
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                Text("Change room photo")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 8)
                
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
                    await handleRoomPhotoUpdate()
                }
            }, label: {
                Text("Change room photo")
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
            .padding(.top, 8)
            
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
    ChangeRoomPhotoView()
}

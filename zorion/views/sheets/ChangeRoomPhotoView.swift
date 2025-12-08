//
//  ChangeRoomPhotoView.swift
//  zorion
//
//  Created by Jose on 05/12/25.
//

import SwiftUI
import PhotosUI

struct ChangeRoomPhotoView: View {
    @State private var selectedRoomPicture: String = ""
    @State private var isShowingAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var useCustomImage: Bool = false
    @Environment(\.dismiss) var dismiss
    
    func handleRoomPhotoUpdate() async {
        if useCustomImage {
            do {
                try await roomPictureUpdateCustom(uiImage: selectedImage!)
                
                useCustomImage = false
                dismiss()
            } catch {
                self.alertTitle = "Oops.. There Is An Error"
                self.alertMessage = "\(error.localizedDescription)"
                self.isShowingAlert = true
                useCustomImage = false
                return
            }
        } else {
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
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.zorionGray, lineWidth: 0.5)
                                )
                        } else {
                            Image(systemName: "plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                                .padding(23)
                                .foregroundColor(.zorionGray)
                                .overlay(
                                    Circle()
                                        .stroke(Color.zorionGray, lineWidth: 0.5)
                                )
                        }
                    }
                    .onChange(of: selectedItem) { oldValue, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                
                                await MainActor.run {
                                    self.selectedImage = uiImage
                                    self.selectedRoomPicture = "custom_uploaded_image"
                                    useCustomImage = true
                                }
                            }
                        }
                    }
                    
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

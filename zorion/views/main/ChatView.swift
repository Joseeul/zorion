//
//  ChatView.swift
//  zorion
//
//  Created by Jose on 25/11/25.
//

import SwiftUI
import PhotosUI

struct ChatView: View {
    @State private var messageContent: String = ""
    @State private var chatData: [MessageModel] = []
    @State var roomId: UUID
    @State private var isLoading: Bool = false
    @State private var isShowingAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @EnvironmentObject var tabBarManager: TabBarManager
    
    func handleChat() async {
        do {
            try await insertChat(roomId: roomId, message: messageContent, messageImage: selectedImage)
            
            messageContent = ""
            selectedImage = nil
            selectedItem = nil
        } catch {
            self.alertTitle = "Oops.. There Is An Error"
            self.alertMessage = "\(error.localizedDescription)"
            self.isShowingAlert = true
            return
        }
    }
    
    func fetchChat() async {
        isLoading = true
        
        do {
            chatData = try await fetchMessage(roomId: roomId)
        } catch {
            isLoading = false
            self.alertTitle = "Oops.. There Is An Error"
            self.alertMessage = "\(error.localizedDescription)"
            self.isShowingAlert = true
            return
        }
        
        isLoading = false
    }
    
    func dateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd/MM/yyyy '-' hh.mm a"
        
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        let result = formatter.string(from: date)
        
        return result
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if isLoading {
                ProgressView("Loading chats data...")
            } else {
                Text("Chats")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                Divider()
                    .padding(.horizontal)
                
                ScrollView {
                    ForEach(0..<chatData.count, id: \.self) { index in
                        HStack(alignment: .bottom) {
                            AsyncImage(url: chatData[index].user.profile_picture) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(.circle)
                                    .frame(width: 42)
                            } placeholder: {
                                Color.gray.opacity(0.3)
                                    .frame(width: 42, height: 42)
                                    .overlay(
                                        ProgressView()
                                            .tint(.gray)
                                    )
                                    .clipShape(.circle)
                            }
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(chatData[index].user.username)
                                        .fontWeight(.semibold)
                                    
                                    Text("at \(dateFormatter(date: chatData[index].created_at))")
                                        .font(.caption)
                                        .foregroundStyle(.zorionGray)
                                        .fontWeight(.light)
                                }
                                
                                Text(chatData[index].message)
                                    .font(.subheadline)
                            }
                        }
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .defaultScrollAnchor(.bottom)
                .padding(.horizontal)
                
                Spacer()
                
                if let image = selectedImage {
                    HStack {
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                                .clipped()
                            
                            Button {
                                selectedImage = nil
                                selectedItem = nil
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                            .offset(x: 5, y: -5)
                        }
                        Spacer()
                    }
                    .padding(.bottom, 4)
                    .padding(.horizontal)
                }
                
                HStack {
                    TextField(
                        "Type here...",
                        text: $messageContent
                    )
                    .padding(.vertical, 12)
                    .padding(.horizontal, 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(
                                Color.zorionGray,
                                lineWidth: 0.5
                            )
                    )
                    
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Image(systemName: "paperclip")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 16, height: 16)
                            .foregroundColor(.zorionGray)
                            .fontWeight(.semibold)
                            .padding(14)
                            .background(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 100)
                                    .stroke(Color.zorionGray, lineWidth: 0.5)
                            )
                    }
                    .onChange(of: selectedItem) { oldValue, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                await MainActor.run {
                                    self.selectedImage = uiImage
                                }
                            }
                        }
                    }
                    
                    Button(action: {
                        Task {
                            await handleChat()
                        }
                    }, label: {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 16, height: 16)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    })
                    .padding(14)
                    .background(.zorionPrimary)
                    .clipShape(Circle())
                }
                .background(Color.white)
                .padding(.horizontal)
            }
        }
        .alert(alertTitle, isPresented: $isShowingAlert, presenting: alertMessage) {
            message in Button("OK", role: .cancel) {}
        } message: {
            message in Text(message)
        }
        .onAppear {
            tabBarManager.isVisible = false
        }
        .task {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                return
            }
            
            await fetchChat()
        }
    }
}

#Preview {
    ChatView(roomId: UUID())
        .environmentObject(TabBarManager())
}

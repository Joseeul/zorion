//
//  ChatView.swift
//  zorion
//
//  Created by Jose on 25/11/25.
//

import SwiftUI
import Supabase
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
    
    private let client = SupabaseManager.shared.client
    
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
    
    func setupRealtimeChat() async {
        var channel = client.channel("room:\(roomId)")
        
        let changeStream = channel.postgresChange(
            AnyAction.self,
            schema: "public",
            table: "messages",
            filter: "room_id=eq.\(roomId)"
        )
        
        await channel.subscribe()
        
        for await change in changeStream {
            switch change {
            case .insert(let action):
                if let messageId = action.record["id"]?.intValue {
                    do {
                        if let newMessage = try await fetchSingleMessage(messageId: messageId) {
                            
                            if !chatData.contains(where: { $0.id == newMessage.id }) {
                                await MainActor.run {
                                    withAnimation {
                                        chatData.append(newMessage)
                                    }
                                }
                            }
                        }
                    } catch {
                        print("Error fetching realtime message details: \(error)")
                    }
                }
                
            default: break
            }
        }
    }
    
    func unsubsRealtimeChat() async {
        var channel = client.channel("room:\(roomId)")
        
        await channel.unsubscribe()
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
                
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(0..<chatData.count, id: \.self) { index in
                            HStack(alignment: .top) {
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
                                    
                                    if let imageString = chatData[index].message_image,
                                       let url = URL(string: imageString) {
                                        
                                        AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                                    .frame(height: 200)
                                                    .frame(maxWidth: .infinity)
                                                    .background(Color.gray.opacity(0.1))
                                                    .cornerRadius(12)
                                                
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(maxHeight: 300)
                                                    .cornerRadius(12)
                                                    .padding(.top, 4)
                                                
                                            case .failure:
                                                Image(systemName: "photo.badge.exclamationmark")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: 50)
                                                    .foregroundColor(.gray)
                                                    .frame(maxWidth: .infinity)
                                                    .padding()
                                                    .background(Color.gray.opacity(0.1))
                                                    .cornerRadius(12)
                                                
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                    }
                                    
                                    Text(chatData[index].message)
                                        .font(.subheadline)
                                }
                            }
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .onChange(of: chatData.count) {
                        if let lastId = chatData.last?.id {
                            withAnimation {
                                proxy.scrollTo(lastId, anchor: .bottom)
                            }
                        }
                    }
                    .defaultScrollAnchor(.bottom)
                    .padding(.horizontal)
                }
                
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
        .onDisappear {
            Task {
                await unsubsRealtimeChat()
            }
        }
        .task {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                return
            }
            
            await fetchChat()
            await setupRealtimeChat()
        }
    }
}

#Preview {
    ChatView(roomId: UUID())
        .environmentObject(TabBarManager())
}

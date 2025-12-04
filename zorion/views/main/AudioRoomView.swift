//
//  AudioRoomView.swift
//  zorion
//
//  Created by Jose on 02/12/25.
//

import SwiftUI
import StreamVideo

struct AudioRoomView: View {
    @State var call: Call
    @ObservedObject var state: CallState
    @State private var callCreated: Bool = false
    @State var roomId: UUID
    @Environment(\.dismiss) var dismiss
    @State private var micIsOpen: Bool = false
    
    private var client: StreamVideo
    private let apiKey: String = "2qb8kbr3uzjb"
    private let userId: String = UserDefaults.standard.string(forKey: "userId")!
    private let username: String = UserDefaults.standard.string(forKey: "userUsername")!
    private let token: String = UserDefaults.standard.string(forKey: "JWT")!
    
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    
    init(roomId: UUID) {
        self._roomId = State(initialValue: roomId)
        let user = User(
            id: userId,
            name: username,
            imageURL: UserDefaults.standard.url(forKey: "userImage")
        )
        
        self.client = StreamVideo(
            apiKey: apiKey,
            user: user,
            token: .init(stringLiteral: token)
        )
        
        let call = client.call(callType: "audio_room", callId: roomId.uuidString)
        
        self.call = call
        self.state = call.state
    }
    
    var headerView: some View {
        VStack {
            HStack {
                HStack(spacing: 5) {
                    Circle()
                        .foregroundStyle(callCreated ? Color.green : Color.red)
                        .frame(width: 8, height: 8)
                    Text(callCreated ? "Voice Connected" : "Connecting...")
                        .font(.caption)
                        .foregroundColor(.zorionGray)
                }
                
                Spacer()
            }
            
            Divider()
                .padding(.top, 8)
        }
        .padding()
    }
    
    var loadingView: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .zorionPrimary))
                .scaleEffect(1.5)
            Text("Connecting to server...")
                .foregroundColor(.gray)
                .padding(.top, 10)
        }
        .padding(.top, 50)
    }
    
    var controlBar: some View {
        HStack(spacing: 20) {
            Button(action: {
                Task {
                    call.leave()
                    dismiss()
                }
            }) {
                ZStack {
                    Circle()
                        .fill(Color.meetRed)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "phone.down.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
            
            Button(action: {
                micIsOpen = !micIsOpen
                
                Task {
                    if micIsOpen == true {
                        try await call.microphone.enable()
                    } else if micIsOpen == false {
                        try await call.microphone.disable()
                    }
                }
            }) {
                ZStack {
                    Circle()
                        .fill(call.microphone.status == .enabled ? Color.white : Color.meetButtonGray)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: call.microphone.status == .enabled ? "mic.fill" : "mic.slash.fill")
                        .font(.system(size: 20))
                        .foregroundColor(call.microphone.status == .enabled ? .black : .white)
                }
            }
            
            Button(action: {
                Task { try await call.speaker.enableAudioOutput() }
            }) {
                ZStack {
                    Circle()
                        .fill(call.speaker.status == .enabled ? Color.white : Color.meetButtonGray)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: call.speaker.status == .enabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                        .font(.system(size: 20))
                        .foregroundColor(call.speaker.status == .enabled ? .black : .white)
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .background(Color(uiColor: .systemGray6))
        .clipShape(Capsule())
        .padding(.horizontal, 30)
        .padding(.bottom, 20)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    if callCreated {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(state.participants, id: \.id) { participant in
                                ParticipantView(participant: participant)
                            }
                        }
                        .padding()
                    } else {
                        loadingView
                    }
                }
                
                if callCreated {
                    Spacer()
                    controlBar
                        .padding(.bottom, 30)
                }
            }
        }
        .task {
            Task {
                guard !callCreated else { return }
                
                do {
                    try await call.join()
                    callCreated = true
                } catch {
                    if "\(error)".contains("call does not exist") {
                        try await call.join(create: true)
                        callCreated = true
                    } else {
                        print("Join failed with unexpected error: \(error)")
                    }
                }
            }
        }
    }
}

struct ParticipantView: View {
    var participant: CallParticipant
    
    private let speakingColor: Color = .blue
    private let muteColor: Color = .red
    private let cardBackground: Color = .white
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                AsyncImage(url: participant.profileImageURL) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(Color(uiColor: .systemGray4))
                }
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(speakingColor, lineWidth: participant.isSpeaking ? 3 : 0)
                        .animation(.easeInOut(duration: 0.2), value: participant.isSpeaking)
                )
                
                if !participant.hasAudio {
                    Image(systemName: "mic.slash.fill")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(6)
                        .background(muteColor)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(cardBackground, lineWidth: 2)
                        )
                        .offset(x: 5, y: 5)
                }
            }
            
            Text(participant.name.isEmpty ? participant.userId : participant.name)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
                .lineLimit(1)
                .padding(.horizontal, 8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension Color {
    static let meetDarkGray = Color(red: 0.12, green: 0.12, blue: 0.12)
    static let meetTileColor = Color(red: 0.24, green: 0.25, blue: 0.26)
    static let meetRed = Color(red: 0.92, green: 0.26, blue: 0.21)
    static let meetBlue = Color(red: 0.53, green: 0.81, blue: 0.98)
    static let meetButtonGray = Color(red: 0.24, green: 0.25, blue: 0.26)
}

#Preview {
    PreviewWrapper()
}

struct PreviewWrapper: View {
    init() {
        UserDefaults.standard.set("dummy_user_id", forKey: "userId")
        UserDefaults.standard.set("Preview User", forKey: "userUsername")
        UserDefaults.standard.set("dummy_jwt_token", forKey: "JWT")
    }
    
    var body: some View {
        AudioRoomView(roomId: UUID())
    }
}

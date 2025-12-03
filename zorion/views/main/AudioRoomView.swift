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
            name: username, // name and imageURL are used in the UI
            imageURL: UserDefaults.standard.url(forKey: "userImage")
        )
        
        // Initialize Stream Video client
        self.client = StreamVideo(
            apiKey: apiKey,
            user: user,
            token: .init(stringLiteral: token)
        )
        
        // Initialize the call object
        
        let call = client.call(callType: "audio_room", callId: roomId.uuidString)
        
        self.call = call
        self.state = call.state
    }
    
    var headerView: some View {
        HStack {
            Image(systemName: "number")
                .foregroundColor(.gray)
            Text("General Voice") // Bisa diganti nama room
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
            
            // Indikator Koneksi
            HStack(spacing: 5) {
                Circle()
                    .fill(callCreated ? Color.discordGreen : .orange)
                    .frame(width: 8, height: 8)
                Text(callCreated ? "Connected" : "Connecting...")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.discordDarkGray)
    }
    
    var loadingView: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
            Text("Connecting to server...")
                .foregroundColor(.gray)
                .padding(.top, 10)
        }
        .padding(.top, 50)
    }
    
    var controlBar: some View {
        HStack(spacing: 30) {
            // Mute/Unmute Button
            Button(action: {
                Task { try? await call.microphone.toggle() }
            }) {
                VStack {
                    Image(systemName: call.microphone.status == .enabled ? "mic.fill" : "mic.slash.fill")
                        .font(.title2)
                        .foregroundColor(call.microphone.status == .enabled ? .white : .discordRed)
                        .frame(width: 50, height: 50)
                        .background(Color.discordCard)
                        .clipShape(Circle())
                    Text("Mic")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            // Leave Button (Merah Besar)
            Button(action: {
                Task {
                    call.leave()
                    // Tambahkan logic dismiss view di sini jika perlu
                    // dismiss()
                }
            }) {
                VStack {
                    Image(systemName: "phone.down.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.discordRed)
                        .clipShape(Circle())
                    Text("Disconnect")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            // Speaker Toggle (Optional)
            Button(action: {
//                Task { try? await call.speaker.toggle() }
            }) {
                VStack {
                    Image(systemName: call.speaker.status == .enabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.discordCard)
                        .clipShape(Circle())
                    Text("Speaker")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 20)
        .padding(.bottom, 10) // Extra padding for safe area
        .frame(maxWidth: .infinity)
        .background(Color.discordDarkGray)
        .cornerRadius(20, corners: [.topLeft, .topRight])
    }
    
    var body: some View {
        ZStack {
            // Background ala Discord
            Color.discordBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Main Content (Grid Peserta)
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
                
                // Bottom Controls
                if callCreated {
                    controlBar
                }
            }
        }
        .task {
            Task {
                guard !callCreated else { return }
                
                do {
                    // Coba join sebagai participant
                    try await call.join()
                    callCreated = true
                } catch {
                    // cek apakah errornya karena "call tidak ada"
                    if "\(error)".contains("call does not exist") {
                        // user pertama → buat call
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
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                // Avatar Circle
                AsyncImage(url: participant.profileImageURL) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                }
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(
                            participant.isSpeaking ? Color.discordGreen : Color.clear,
                            lineWidth: 4
                        )
                )
                .shadow(color: participant.isSpeaking ? Color.discordGreen.opacity(0.5) : .clear, radius: 5)
                
                // Mute Icon Indicator (Small red mic)
                if !participant.hasAudio {
                    Image(systemName: "mic.slash.fill")
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color.discordRed)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.discordCard, lineWidth: 2))
                        .offset(x: 0, y: 0)
                }
            }
            
            // Username
            Text(participant.name.isEmpty ? participant.userId : participant.name)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.discordCard)
        .cornerRadius(12)
    }
}

// Helper untuk rounded corner spesifik
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
    static let discordBackground = Color(red: 0.18, green: 0.19, blue: 0.21) // #2F3136
    static let discordCard = Color(red: 0.22, green: 0.24, blue: 0.26)      // #36393F
    static let discordGreen = Color(red: 0.26, green: 0.73, blue: 0.45)     // #43B581
    static let discordRed = Color(red: 0.94, green: 0.28, blue: 0.28)       // #F04747
    static let discordDarkGray = Color(red: 0.13, green: 0.14, blue: 0.15)  // #202225
}

#Preview {
    AudioRoomView(roomId: UUID())
}

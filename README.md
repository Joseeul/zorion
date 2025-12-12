# Zorion

Zorion is an iOS community engagement application built with SwiftUI. It creates a space for users to join rooms, interact via real-time chat, participate in polls, and engage in live audio conversations. A unique feature of Zorion is its "Content Creator Validation" system, which allows users to verify their social media influence (TikTok, YouTube, Instagram) to unlock exclusive room creation privileges.

## 🚀 Features

- **Authentication**: 
  - Secure Sign Up & Sign In (Email/Password).
  - OAuth integration (Google & Discord).
- **Creator Verification**: 
  - Integrated validation system to check follower counts on platforms like TikTok, YouTube, and Instagram.
  - Users with >1000 followers gain "Content Creator" status and can create their own community rooms.
- **Room Management**:
  - Browse and search for community rooms.
  - Join rooms and view participants.
  - Creators can customize room details (Name, Description, Photo).
- **Real-time Interaction**:
  - **Chat**: Live messaging with support for image uploads.
  - **Audio Rooms**: Voice channels powered by Stream Video SDK.
  - **Voting**: Create and participate in polls within rooms.
- **Profile Management**:
  - Customizable user profiles (Username, Profile Picture).
  - Account settings and logout functionality.

## 🛠 Tech Stack

- **Language**: Swift 5
- **UI Framework**: SwiftUI
- **Backend-as-a-Service**: [Supabase](https://supabase.com/)
  - Database (PostgreSQL)
  - Authentication
  - Storage (Image buckets)
  - Realtime (Chat updates)
- **Audio/Video SDK**: [Stream Video & Audio](https://getstream.io/video/docs/ios/)
- **Networking**: URLSession & Swift Concurrency (Async/Await)
- **Dependency Manager**: Swift Package Manager (SPM)

## 📂 Project Structure

The project follows a clean architecture separating Views, Models, and Controllers:

```
zorion/
├── Assets.xcassets/       # Images, Colors, and Icons
├── component/             # Reusable UI components (e.g., RoomHeader, VoteCard)
├── controller/            # Business logic and API managers (Auth, Room, User, etc.)
├── db/                    # Database configuration (Supabase config)
├── helper/                # Utility helpers (TabBarManager, Keyboard dismissal)
├── model/                 # Data models (Codable structs)
├── route/                 # Navigation path enums
└── views/                 # SwiftUI Views
    ├── auth/              # Authentication screens
    ├── creatorValidation/ # Logic for verifying creator stats
    ├── main/              # Core app screens (Discover, Rooms, Chat, Profile)
    └── sheets/            # Modal sheets (Edit profile, Create room, etc.)
```

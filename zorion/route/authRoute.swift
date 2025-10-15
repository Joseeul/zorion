//
//  authRoute.swift
//  zorion
//
//  Created by Jose Andreas on 15/10/25.
//

import Foundation

enum authRoute: Hashable {
    case ChooseValidationView
    case AccountValidationView(platform: String)
    case CreateUsernameView
    case CreateCreatorRoomView
    case CreateProfilePictureView
}

//
//  dismissKeyboard.swift
//  zorion
//
//  Created by Jose Andreas on 16/10/25.
//

import Foundation
import SwiftUI
import UIKit

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

//
//  zorionApp.swift
//  zorion
//
//  Created by Jose Andreas on 10/10/25.
//

import SwiftUI

@main
struct zorionApp: App {
    @State var showingSplash = true
    
    // TODO: nanti disini harus ditambahin validasi apakah user sudah ada atau belum. kalo belum ada ke login, kalau sudah ada langsung ke home
    
    var body: some Scene {
        WindowGroup {
            if showingSplash {
                SplashView(showingSplash: $showingSplash)
            } else {
                LoginView()
            }
        }
    }
}

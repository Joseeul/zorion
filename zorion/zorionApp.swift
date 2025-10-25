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
    
    @AppStorage("isLogin") var loggedUser: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if showingSplash {
                SplashView(showingSplash: $showingSplash)
            } else if loggedUser == false {
                AuthView()
            } else {
                HomeView()
            }
        }
    }
}

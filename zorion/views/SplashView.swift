//
//  SplashView.swift
//  zorion
//
//  Created by Jose Andreas on 11/10/25.
//

import SwiftUI

struct SplashView: View {
    @Binding var showingSplash: Bool
    @State var scaleAmount: CGFloat = 1
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.zorionPrimary, Color.zorionSecondary], startPoint: .top, endPoint: .bottom)
            
            Image("zorion_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(scaleAmount)
                .frame(width: 80)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeOut(duration: 1)) {
                scaleAmount = 0.6
            }
            
            withAnimation(.easeInOut(duration: 1).delay(1)) {
                scaleAmount = 80
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showingSplash = false
            }
        }
    }
}

#Preview {
    SplashView(showingSplash: .constant(true))
}

//
//  ContentView.swift
//  zorion
//
//  Created by Jose Andreas on 10/10/25.
//

import SwiftUI

// TODO: button oauthnya blum full jadi harus diklik lewat textnya
// TODO: keyboard kalau klik di area luar belom bisa nutup

struct AuthView: View {
    @State var path = NavigationPath()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSignIn: Bool = true //buat nandain sekarang lagi signin/signup (untuk conditional rendering)
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Spacer()
                
                Image("zorion_logo_gradient")
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom, 40)
                    .frame(width: 68)
                
                TextField(
                    "Email",
                    text: $email
                )
                .padding(.vertical, 12)
                .padding(.horizontal, 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            Color.zorionGray,
                            lineWidth: 0.5
                        )
                )
                .padding(.bottom, 8)
                .keyboardType(.emailAddress)
                .disableAutocorrection(true)
                
                SecureField(
                    "Password",
                    text: $password
                )
                .padding([.top, .bottom], 12)
                .padding([.trailing, .leading], 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            Color.zorionGray,
                            lineWidth: 0.5
                        )
                )
                .disableAutocorrection(true)
                
                Button(action: {
                    if !isSignIn {
                        path.append(authRoute.ChooseValidationView)
                    }
                }, label: {
                    Text(isSignIn ? "Sign In" : "Sign Up")
                        .frame(maxWidth: .infinity)
                })
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom], 12)
                .padding([.trailing, .leading], 8)
                .fontWeight(.semibold)
                .background(Color.zorionPrimary)
                .foregroundStyle(.white)
                .cornerRadius(8)
                .padding(.top, 16)
                
                HStack(spacing: 4) {
                    Text("By signing \(isSignIn ? "in" : "up") you agree to our")
                    
                    Text("Terms")
                        .foregroundColor(.zorionPrimary)
                        .fontWeight(.semibold)
                    
                    Text("and")
                    
                    Text("Privacy Policy")
                        .foregroundColor(.zorionPrimary)
                        .fontWeight(.semibold)
                }
                .font(.caption)
                .padding(.top, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.zorionGray)
                    
                    Text("or")
                        .font(.subheadline)
                        .foregroundColor(Color.zorionGray)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.zorionGray)
                }
                .padding([.top, .bottom], 16)
                
                Group {
                    Button(action: {}, label: {
                        Image("google_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16)
                        
                        Text("Continue with Google")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    })
                    .frame(maxWidth: .infinity)
                    .padding([.top, .bottom], 12)
                    .padding([.trailing, .leading], 8)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.zorionGray, lineWidth: 0.5)
                    )
                    .padding(.bottom, 8)
                    
                    Button(action: {}, label: {
                        Image(systemName: "apple.logo")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.black)
                            .frame(width: 16)
                        
                        Text("Continue with Apple")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    })
                    .frame(maxWidth: .infinity)
                    .padding([.top, .bottom], 12)
                    .padding([.trailing, .leading], 8)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.zorionGray, lineWidth: 0.5)
                    )
                    .padding(.bottom, 8)
                    
                    Button(action: {}, label: {
                        Image("microsoft_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16)
                        
                        Text("Continue with Microsoft")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    })
                    .frame(maxWidth: .infinity)
                    .padding([.top, .bottom], 12)
                    .padding([.trailing, .leading], 8)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.zorionGray, lineWidth: 0.5)
                    )
                }
                
                Spacer()
                
                HStack {
                    Text(isSignIn ? "Never use Zorion before?" : "Already use Zorion before?")
                        .font(.subheadline)
                    
                    Button(action: {
                        isSignIn = !isSignIn
                    }, label: {
                        Text(isSignIn ? "Sign Up" : "Sign In")
                            .font(.subheadline)
                            .foregroundColor(.zorionPrimary)
                            .fontWeight(.semibold)
                    })
                }
            }
            .padding()
            .onTapGesture {
                hideKeyboard()
            }
            .navigationDestination(for: authRoute.self) {
                destination in switch destination {
                case .ChooseValidationView: ChooseValidationView(path: $path)
                case .AccountValidationView(let platform): AccountValidationView(platform: platform, path: $path)
                case .CreateUsernameView: CreateUsernameView(path: $path)
                case .CreateCreatorRoomView: CreateCreatorRoomView(path: $path)
                case .CreateProfilePictureView: CreateProfilePictureView()
                }
            }
        }
        .tint(Color.zorionPrimary)
    }
}

#Preview {
    AuthView()
}

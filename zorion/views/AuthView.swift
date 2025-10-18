//
//  ContentView.swift
//  zorion
//
//  Created by Jose Andreas on 10/10/25.
//

import SwiftUI

// TODO: button oauthnya blum full jadi harus diklik lewat textnya
// TODO: handle oauth kirim parameter sesuai sama button yang di pencet

struct AuthView: View {
    @State var path = NavigationPath()
    @State private var inputedEmail: String = ""
    @State private var inputedPassword: String = ""
    @State private var isSignIn: Bool = true //buat nandain sekarang lagi signin/signup (untuk conditional rendering)
    @State private var isShowingAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    func handleAuth() {
        if inputedEmail.isEmpty || inputedPassword.isEmpty {
            self.alertTitle = "Missing Input"
            self.alertMessage = "Please fill all the field."
            self.isShowingAlert = true
            return
        }
        
        if inputedEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || inputedPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.alertTitle = "Missing Input"
            self.alertMessage = "Please fill all the field."
            self.isShowingAlert = true
            return
        }
        
        if inputedPassword.count <= 6 {
            self.alertTitle = "Password Too Short"
            self.alertMessage = "Password minimum 6 characters"
            self.isShowingAlert = true
            return
        }
        
        if isSignIn {
            // kalo true langsung panggil function signin
        } else {
            UserDefaults.standard.set(inputedEmail, forKey: "userEmail")
            UserDefaults.standard.set(inputedPassword, forKey: "userPassword")

            path.append(authRoute.ChooseValidationView)
        }
    }
    
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
                    text: $inputedEmail
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
                    text: $inputedPassword
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
                    handleAuth()
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
                    
                    Button(action: {
                        Task {
                            await AuthController().discordAuth()
                        }
                    }, label: {
                        Image("discord_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16)
                        
                        Text("Continue with Discord")
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
                    
                    Button(action: {
                        Task {
                            await AuthController().signOutUser()
                        }
                    }, label: {
                        Text("SIGN OUT BUTTON")
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
            .alert(alertTitle, isPresented: $isShowingAlert, presenting: alertMessage) {
                message in Button("OK", role: .cancel) {}
            } message: {
                message in Text(message)
            }
        }
        .tint(Color.zorionPrimary)
    }
}

#Preview {
    AuthView()
}

//
//  LoginView.swift
//  RememberBirthday
//
//  Created by BigMacProMeal on 9/5/25.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationView{
            VStack{
                // Header
                HeaderView(title: "Remember Birthday", subtitle: "Never forget a birthday again!", angle: 15, backgroundColor: Color.yellow)
                
                // Login Form
                Form{
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                    }
                    
                    TextField("Email address", text: $viewModel.email)
                        .textFieldStyle(DefaultTextFieldStyle())
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(DefaultTextFieldStyle())
                    
                    ButtonView(
                        title: viewModel.isLoading ? "Logging In..." : "Log In",
                        backgroundColor: .blue
                    ) {
                        viewModel.login()
                    }
                    .padding()
                    .disabled(viewModel.isLoading)
                }
                .offset(y: -20)
                
                // Create Account Stuff
                VStack {
                    Text("New around here?")
                    NavigationLink("Create An Account",
                                   destination: RegisterView())
                }
                .padding(.bottom, 40)
                
                Spacer()
            }
        }
    }
}

#Preview {
    LoginView()
}

//
//  RegisterView.swift
//  RememberBirthday
//
//  Created by BigMacProMeal on 9/6/25.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                HeaderView(
                    title: "Register",
                    subtitle: "Start tracking birthdays",
                    angle: -15,
                    backgroundColor: .pink
                )
                .offset(y: -50)
                
                Form {
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                    }
                    
                    TextField("Full Name", text: $viewModel.name)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                    
                    TextField("Email Address", text: $viewModel.email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(DefaultTextFieldStyle())
                    
                    ButtonView(
                        title: viewModel.isLoading ? "Creating Account..." : "Create Account",
                        backgroundColor: .green
                    ) {
                        viewModel.register()
                    }
                    .padding()
                    .disabled(viewModel.isLoading)
                }
                .offset(y: -20)
                
                // Back to Login
                VStack {
                    Text("Already have an account?")
                    Button("Sign In") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .padding(.bottom, 40)
                
                Spacer()
            }
        }
        .onChange(of: viewModel.isLoading) { isLoading in
            if !isLoading && viewModel.errorMessage.isEmpty {
                // Registration successful, dismiss the view
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

#Preview {
    RegisterView()
}

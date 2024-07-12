//
//  SignInView.swift
//  MovieList
//
//  Created by Devika Shendkar on 4/28/23.
//

import SwiftUI
import Firebase

struct SignInView: View {
    enum Field{
        case email, password
    }
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonsDisabled = true
    @State private var path = NavigationPath()
    @FocusState private var focusField: Field?
    
    var body: some View {
        NavigationStack (path:$path){
            Group{
                TextField("E-mail", text: $email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .focused($focusField, equals: .email)
                    .onSubmit {
                        focusField = .password
                    }
                    .onChange(of: email){
                        _ in
                        enableButtons()
                    }
                SecureField("Password", text: $password)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.done)
                    .focused($focusField, equals: .password)
                    .onSubmit {
                        focusField = nil
                    }
                    .onChange(of: password){
                        _ in
                        enableButtons()
                    }
            }
            .textFieldStyle(.roundedBorder)
            .overlay{
                RoundedRectangle(cornerRadius: 5).stroke(.gray.opacity(0.5), lineWidth: 2)
            }
            .padding(.horizontal)
            
            HStack{
                Button{
                    register()
                }label: {
                    Text("Sign Up")
                }
                .padding(.trailing)
                Button{
                    login()
                }label: {
                    Text("Log In")
                }
                .padding(.leading)
            }
            .disabled(buttonsDisabled)
            .buttonStyle(.borderedProminent)
            .tint(Color(red: 0.91, green: 0.28, blue: 0.28))
            .font(.title2)
            .padding(.top)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: String.self ){ view in
                if view == "MovieView"{
                    MovieView()
                }
                
            }
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("Ok", role: .cancel){
                
            }
        }.onAppear{
            if Auth.auth().currentUser != nil{
                print("Login Success")
                path.append("MovieView")
            }
        }
        
    }
    
    func enableButtons(){
        let emailIsGood = email.count > 6 && email.contains("@")
        let passwordIsGood = password.count > 6
        buttonsDisabled = !(emailIsGood && passwordIsGood)
    }
    
    func register(){
        Auth.auth().createUser(withEmail: email, password: password){
            result, error in
            if let error = error{
                print("Sign Up Error: \(error.localizedDescription)")
                alertMessage = "Sign Up Error: \(error.localizedDescription)"
                showingAlert = true
            }else{
                print("Registration Success")
                path.append("MovieView")
            }
        }
    }
    
    func login(){
        Auth.auth().signIn(withEmail: email, password: password){
            result, error in
            if let error = error{
                print("Login Error: \(error.localizedDescription)")
                alertMessage = "Login Error: \(error.localizedDescription)"
                showingAlert = true
            }else{
                print("Login Success")
                path.append("MovieView")
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

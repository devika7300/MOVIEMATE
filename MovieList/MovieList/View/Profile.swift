//
//  ProfileView.swift
//  MovieList
//
//  Created by Devika Shendkar on 5/1/23.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct Profile: View {
    // Create an instance of ProfileViewModel and initialize it as a StateObject
    @StateObject var viewModel = ProfileModel()
    
    // Create a state variable to control the ImagePicker sheet
    @State private var showImagePicker = false
    
    var body: some View {
        VStack {
            // Display the profile image or a placeholder if it's not available
            if let profileImage = viewModel.profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .foregroundColor(.gray)
            }
            
            // Button to show the ImagePicker sheet
            Button(action: { showImagePicker = true }) {
                Text("Change Profile Image")
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $viewModel.profileImage)
            }
            
            // Form to edit the user's profile details
            Form {
                Section(header: Text("Profile Details")) {
                    TextField("Name", text: $viewModel.name)
                    TextField("Country", text: $viewModel.country)
                    TextField("City", text: $viewModel.city)
                    TextField("Phone Number", text: $viewModel.number)
                }
            }
            
            // Button to save the changes to the user's profile
            Button(action: viewModel.updateProfile) {
                Text("Save")
            }
        }
        .padding()
        .navigationBarTitle("Profile")
        // Call the loadProfile method of the viewModel when the view appears
        .onAppear(perform: viewModel.loadProfile)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}


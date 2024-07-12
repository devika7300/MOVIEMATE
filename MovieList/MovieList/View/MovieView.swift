//
//  MovieView.swift
//  MovieList
//
//  Created by Devika Shendkar on 4/17/23.
//
import SwiftUI

import Foundation/*The application follows the Model-View-ViewModel (MVVM) architecture pattern, in which each view has a matching ViewModel that retrieves the necessary data from the server and sends it to the related view. The data must be fetched from the server and filled into the appropriate ViewModel using the MovieFetch1 class.*/
import Firebase
import FirebaseStorage
import FirebaseFirestore

//View which provides with all the movies from now playing in tmdb app
struct NowPlayingView: View {
    @Environment(\.dismiss) private var dismiss
    // favoriteListViewModel is an observed object that holds the user's favorite movies
    @ObservedObject var favoriteListViewModel = FavoriteViewModel()

    // nowPlayingMovies is an array of movies that are currently playing
    var nowPlayingMovies: [Movie]

    // imageSize is a constant that represents the size of the movie poster image in the list
    let imageSize: CGFloat = 100

    var body: some View {
        NavigationView {
            List {
                
                // loop through each movie in the nowPlayingMovies array
                ForEach(nowPlayingMovies) { movie in
                    
                    // NavigationLink is used to navigate to the MovieDetailView when the user taps on a movie in the list
                    NavigationLink(destination: DetailedMovieView(movie: movie,isFavorite:favoriteListViewModel.isFavorite(movie: movie) )) {
                        HStack {
                            // The movie poster image is displayed using the AsyncImage component, which has three phases: loading, error, and success
                            let posterURL = movie.posterURL
                            AsyncImage(url: posterURL) { phase in
                                if let image = phase.image {
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(height: 70)
                                        .cornerRadius(4)
                                } else if phase.error != nil {
                                    Text(phase.error?.localizedDescription ?? "error")
                                        .foregroundColor(Color.pink)
                                        .frame(width: imageSize, height: imageSize)
                                } else {
                                    ProgressView()
                                        .frame(width: imageSize, height: imageSize)
                                }
                            }
                            VStack(alignment: .leading){
                                // The movie title and vote count are displayed in a VStack
                                Text(movie.title)
                                    .font(.custom("Bebas Neue", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 0.91, green: 0.28, blue: 0.28))
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                                Text(String(movie.voteCount ?? 0) + " Ratings")
                                    .font(.custom("Avenir",size:12))
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            // The heart icon is used to indicate whether the movie is a favorite or not
                            Image(systemName: favoriteListViewModel.isFavorite(movie: movie) ? "heart.fill" : "heart")
                                .foregroundColor(.red)
                                .onTapGesture {
                                    favoriteListViewModel.toggleFavorite(movie: movie)
                                }
                        }
                    }
                    //Each movie in the list is also swipeable, and a swipe action button is displayed that allows the user to delete the movie from the list
                    .swipeActions{
                        Button(role:.destructive){
                            print("Delete")
                        }label: {
                            Label("Delete", systemImage:"trash.circle.fill")
                        }
                    }
                }
            }
            // Set the navigation bar title and font color
            //.navigationBarBackButtonHidden(true)
            .navigationTitle("Now Playing")
            .foregroundColor(Color(red: 0.13, green: 0.15, blue: 0.18))
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Sign Out"){
                        do{
                            try Auth.auth().signOut()
                            print("Log out Successful!")
                            dismiss()
                        }catch{
                            print("Error: Could not sign out")
                        }
                    }
                }
            }
        }
    }
}

//View which provides with all the movies from upcoming section in tmdb app
struct UpcomingView: View {
    // Observed object that stores the user's favorite movies
    @ObservedObject var favoriteListViewModel = FavoriteViewModel()
    @Environment(\.dismiss) private var dismiss
    // An array of upcoming movies to be displayed in the view
    var upcomingMovies: [Movie]
    // The size of the movie poster image
    let imageSize: CGFloat = 100
    
    var body: some View {
        NavigationView {
            List {
                ForEach(upcomingMovies) { movie in
                    // Navigation link that leads to the movie details view
                    NavigationLink(destination: DetailedMovieView(movie: movie, isFavorite: favoriteListViewModel.isFavorite(movie: movie))) {
                        HStack {
                            let posterURL = movie.posterURL
                            // AsyncImage component is used to display the movie's poster, and it has three phases: a loading phase that displays a progress indicator, an error phase that displays an error message, and a success phase that displays the movie's poster image.
                            AsyncImage(url: posterURL) { phase in
                                if let image = phase.image {
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(height: 70)
                                        .cornerRadius(4)
                                } else if phase.error != nil {
                                    Text(phase.error?.localizedDescription ?? "error")
                                        .foregroundColor(Color.pink)
                                        .frame(width: imageSize, height: imageSize)
                                } else {
                                    ProgressView()
                                        .frame(width: imageSize, height: imageSize)
                                }
                            }
                            VStack(alignment: .leading){
                                // The movie title is displayed with a custom font and color, with a maximum of 2 lines and a minimum scale factor of 0.5 to fit the text if it's too long
                                Text(movie.title)
                                    .font(.custom("Bebas Neue", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 0.91, green: 0.28, blue: 0.28))
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                                Text(String(movie.voteCount ?? 0) + " Ratings")
                                    .font(.custom("Avenir",size:12))
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            // The favorite button is displayed with a heart icon that is filled or not depending on whether the movie is in the user's favorite list or not. Tapping the button toggles the movie's favorite status.
                            Image(systemName: favoriteListViewModel.isFavorite(movie: movie) ? "heart.fill" : "heart")
                                .foregroundColor(.red)
                                .onTapGesture {
                                favoriteListViewModel.toggleFavorite(movie: movie)
                                                        }
                        }
                    }
                    // Each movie in the list is also swipeable, and a swipe action button is displayed that allows the user to delete the movie from the list.
                    .swipeActions {
                        Button(role:.destructive) {
                            print("Delete")
                        } label: {
                            Label("Delete", systemImage: "trash.circle.fill")
                        }
                    }
                }
            }
            // The navigation title is set to "Upcoming Movies"
            .navigationTitle("Upcoming Movies")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Sign Out"){
                        do{
                            try Auth.auth().signOut()
                            print("Log out Successful!")
                            dismiss()
                        }catch{
                            print("Error: Could not sign out")
                        }
                    }
                }
            }
        }
    }
}



//View which provides with all the movies from top rated section in tmdb app
struct TopRatedView: View {
    // An instance of the `FavoriteListViewModel` class is used to manage the list of favorite movies
    @ObservedObject var favoriteListViewModel = FavoriteViewModel()
    @Environment(\.dismiss) private var dismiss
    // An array of `Movie` objects that represent the top rated movies
    var topratedMovies: [Movie]
    
    // The size of the movie poster image displayed in the view
    let imageSize: CGFloat = 100
    
    var body: some View {
        NavigationView {
            List {
                // Iterate through each movie in the array of top rated movies
                ForEach(topratedMovies) { movie in
                    // Display a navigation link to the movie detail view when a movie is tapped
                    NavigationLink(destination: DetailedMovieView(movie: movie,isFavorite:favoriteListViewModel.isFavorite(movie: movie) )) {
                        HStack {
                            let posterURL = movie.posterURL
                            // AsyncImage component is used to display the movie's poster, and it has three phases: a loading phase that displays a progress indicator, an error phase that displays an error message, and a success phase that displays the movie's poster image
                            AsyncImage(url: posterURL) { phase in
                                if let image = phase.image {
                                    // If the image is successfully loaded, display it in the view
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(height: 70)
                                        .cornerRadius(4)
                                } else if phase.error != nil {
                                    // If there is an error loading the image, display an error message
                                    Text(phase.error?.localizedDescription ?? "error")
                                        .foregroundColor(Color.pink)
                                        .frame(width: imageSize, height: imageSize)
                                } else {
                                    // If the image is still loading, display a progress indicator
                                    ProgressView()
                                        .frame(width: imageSize, height: imageSize)
                                }
                            }
                            VStack(alignment: .leading){
                                // Display the movie's title and format it with a custom font, size, and color
                                Text(movie.title)
                                    .font(.custom("Bebas Neue", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 0.91, green: 0.28, blue: 0.28))
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                                Text(String(movie.voteCount ?? 0) + " Ratings")
                                    .font(.custom("Avenir",size:12))
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            // Display a heart icon to indicate if the movie is in the user's list of favorites. Tapping the icon will toggle the movie's favorite status.
                            Image(systemName: favoriteListViewModel.isFavorite(movie: movie) ? "heart.fill" : "heart")
                                .foregroundColor(.red)
                                .onTapGesture {
                                favoriteListViewModel.toggleFavorite(movie: movie)
                                                        }
                            
                        }
                    }
                    // Each movie in the list is also swipeable, and a swipe action button is displayed that allows the user to delete the movie from the list
                    .swipeActions{
                        Button(role:.destructive){
                            print("Delete")
                        }label: {
                            Label("Delete", systemImage:"trash.circle.fill")
                        }
                    }
                }
            }
            // Set the navigation title of the view to "Top Rated Movies"
            .navigationTitle("Top Rated Movies")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Sign Out"){
                        do{
                            try Auth.auth().signOut()
                            print("Log out Successful!")
                            dismiss()
                        }catch{
                            print("Error: Could not sign out")
                        }
                    }
                }
            }
        }
    }
}


//View which provides with all the movies from popular movies section in tmdb app
struct PopularView: View {
    // The view model that manages the favorite movies list
    @ObservedObject var favoriteListViewModel = FavoriteViewModel()
    @Environment(\.dismiss) private var dismiss
    // The list of popular movies to display
    var popularMovies: [Movie]
    
    // The size of the movie poster image
    let imageSize: CGFloat = 100
    
    var body: some View {
        NavigationView {
            List {
                // Iterate through each movie in the popularMovies array
                ForEach(popularMovies) { movie in
                    // Create a navigation link that leads to the MovieDetailView for the selected movie
                    NavigationLink(destination: DetailedMovieView(movie: movie,isFavorite:favoriteListViewModel.isFavorite(movie: movie) )) {
                        // Display the movie's poster image using the AsyncImage component
                        HStack {
                            let posterURL = movie.posterURL
                            AsyncImage(url: posterURL) { phase in
                                if let image = phase.image {
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(height: 70)
                                        .cornerRadius(4)
                                } else if phase.error != nil {
                                    Text(phase.error?.localizedDescription ?? "error")
                                        .foregroundColor(Color.pink)
                                        .frame(width: imageSize, height: imageSize)
                                } else {
                                    ProgressView()
                                        .frame(width: imageSize, height: imageSize)
                                }
                            }
                            // Display the movie's title and vote count using VStack
                            VStack(alignment: .leading){
                                Text(movie.title)
                                    .font(.custom("Bebas Neue", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 0.91, green: 0.28, blue: 0.28))
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                                Text(String(movie.voteCount ?? 0) + " Ratings")
                                    .font(.custom("Avenir",size:12))
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                            // Display a heart icon that toggles the favorite status of the movie when tapped
                            Spacer()
                            Image(systemName: favoriteListViewModel.isFavorite(movie: movie) ? "heart.fill" : "heart")
                                .foregroundColor(.red)
                                .onTapGesture {
                                    favoriteListViewModel.toggleFavorite(movie: movie)
                            }
                        }
                    }
                    // Add a swipe action button to delete the movie from the list when swiped
                    .swipeActions {
                        Button(role:.destructive){
                            print("Delete")
                        } label: {
                            Label("Delete", systemImage:"trash.circle.fill")
                        }
                    }
                }
            }
            .navigationTitle("Popular Movies")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Sign Out"){
                        do{
                            try Auth.auth().signOut()
                            print("Log out Successful!")
                            dismiss()
                        }catch{
                            print("Error: Could not sign out")
                        }
                    }
                }
            }
        }
    }
}

struct FavoriteView: View {
    // Create an instance of the FavoriteListViewModel to store the user's favorite movies.
    @ObservedObject var favoriteListViewModel = FavoriteViewModel()
    @Environment(\.dismiss) private var dismiss
    // Set the size of the movie poster image.
    let imageSize: CGFloat = 100
    
    // Define the body of the view.
    var body: some View {
        // Set up a navigation view with a list of movies.
        NavigationView {
            List {
                // Use a ForEach loop to iterate over each movie in the favorite list.
                ForEach(favoriteListViewModel.favoriteList.movies) { movie in
                    // Create a navigation link to the movie's detail view.
                    NavigationLink(destination: DetailedMovieView(movie: movie,isFavorite:favoriteListViewModel.isFavorite(movie: movie) )) {
                        // Create a horizontal stack to display the movie's poster image, title, and favorite icon.
                        HStack {
                            // Load the movie poster image asynchronously.
                            let posterURL = movie.posterURL
                            AsyncImage(url: posterURL) { phase in
                                // If the image has loaded successfully, display it.
                                if let image = phase.image {
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(height: 70)
                                        .cornerRadius(4)
                                }
                                // If there was an error loading the image, display an error message.
                                else if phase.error != nil {
                                    Text(phase.error?.localizedDescription ?? "error")
                                        .foregroundColor(Color.pink)
                                        .frame(width: imageSize, height: imageSize)
                                }
                                // If the image is still loading, display a progress indicator.
                                else {
                                    ProgressView()
                                        .frame(width: imageSize, height: imageSize)
                                }
                            }
                            // Display the movie's title and rating information in a vertical stack.
                            VStack(alignment: .leading){
                                Text(movie.title)
                                    .font(.custom("Bebas Neue", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 0.91, green: 0.28, blue: 0.28))
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                                Text(String(movie.voteCount ?? 0) + " Ratings")
                                    .font(.custom("Avenir",size:12))
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                            // Display a heart icon to indicate whether the movie is favorited.
                            Spacer()
                            Image(systemName: favoriteListViewModel.isFavorite(movie: movie) ? "heart.fill" : "heart")
                                .foregroundColor(.red)
                                // Allow the user to toggle the favorite status of the movie by tapping the heart icon.
                                .onTapGesture {
                                    favoriteListViewModel.toggleFavorite(movie: movie)
                                }
                        }
                    }
                    
                }
            }
            // Set the navigation title to "Favorite Movies".
            .navigationTitle("Favorite Movies")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Sign Out"){
                        do{
                            try Auth.auth().signOut()
                            print("Log out Successful!")
                            dismiss()
                        }catch{
                            print("Error: Could not sign out")
                        }
                    }
                }
            }
        }
    }
}



struct MovieView: View {
    // State variables to control selected tab
    @State private var selectedTab = 0
    //@EnvironmentObject var authView : AuthView
    // State objects for movie fetch and favorite list view model
    @StateObject var movieFetch = FetchMovie()
    @ObservedObject var favoriteListViewModel = FavoriteViewModel()
    @ObservedObject var profileView = ProfileModel()
    @State private var isShowingImagePicker = false
    

    var body: some View {
        // Tab view to display different movie categories
        VStack{
            HStack{
                // Display profile image if available, otherwise display a default image
                if let profileImage = profileView.profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .onTapGesture {
                            // Show the image picker when the user taps the image
                            isShowingImagePicker = true
                        }
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.gray)
                        .onTapGesture {
                            // Show the image picker when the user taps the image
                            isShowingImagePicker = true
                        }
                }
                
              
            }
            TabView(selection: $selectedTab) {
                
                // Now playing movies category
                NowPlayingView(favoriteListViewModel:favoriteListViewModel,nowPlayingMovies: movieFetch.nowPlayingmovies)
                    .tabItem {
                        Image(systemName: "play")
                        Text("Now Playing")
                    }
                    .tag(0)
                
                // Upcoming movies category
                UpcomingView(favoriteListViewModel:favoriteListViewModel,upcomingMovies: movieFetch.upcomingMovies)
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Upcoming")
                    }
                    .tag(1)
                
                // Top rated movies category
                TopRatedView(favoriteListViewModel:favoriteListViewModel,topratedMovies: movieFetch.topRatedMovies)
                    .tabItem {
                        Image(systemName: "star")
                        Text("Top Rated")
                    }
                    .tag(2)
                
                // Favorite movies category
                FavoriteView(favoriteListViewModel: favoriteListViewModel)
                    .tabItem {
                        Image(systemName: "flame")
                        Text("Favorite")
                    }
                    .tag(3)
                
                // Profile
                Profile().tabItem{
                    Image(systemName: "person")
                    Text("Profile")
                }
                    .tag(4)
                
            }.accentColor(Color(red: 0.80, green: 0.35, blue: 0.53))
        }
        .onAppear(perform: profileView.loadProfile)
        .sheet(isPresented: $isShowingImagePicker, onDismiss: profileView.updateProfilePic) {
            ImagePicker(image: $profileView.profileImage)
        }
    }
}


                        

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieView()
        }
    }
}

// Struct for responses from the movie images fetched from TMDB app
struct MovieImagesResponse: Codable {
    let backdrops: [MovieImage]
}

// Struct for responses from the movie images fetched from TMDB app
struct MovieImage: Codable, Identifiable {
    let id = UUID()
    let filePath: String
    
    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
}





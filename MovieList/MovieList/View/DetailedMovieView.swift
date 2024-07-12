//
//  DetailedMovieView.swift
//  MovieList
//
//  Created by Devika Shendkar on 4/17/23.
//
import SwiftUI
import Foundation
struct DetailedMovieView: View {
    // The movie object for which details need to be displayed.
    var movie: Movie
    var isFavorite: Bool
    // State variable that holds the movie images to be displayed.
    @State private var movieImages: [MovieImage] = []
    @State private var showReviewView = false
    // Constant that sets the image size.
    let imageSize: CGFloat = 100
    
    var body: some View {
        // A scroll view that allows scrolling vertically.
        ScrollView {
            // A vertical stack that holds all the UI elements for this view.
            VStack {
                Text(movie.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                
                // Conditionally display the movie images in a horizontal scroll view.
                if movieImages.count > 0 {
                    ScrollView(.horizontal) { // Enable horizontal scrolling
                        LazyHGrid(rows: [GridItem(.flexible())]) {
                            ForEach(movieImages.prefix(6)) { image in
                                let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(image.filePath)")!
                                // Asynchronously load and display the image using AsyncImage.
                                AsyncImage(url: imageURL) { phase in
                                    if let image = phase.image {
                                        image.resizable()
                                            .scaledToFit()
                                            .frame(height: 200)
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
                                .aspectRatio(16/9, contentMode: .fit)
                                .cornerRadius(8)
                                .padding()
                            }
                        }
                    }
                }
                
                // Display the release date of the movie.
                Text("Release Date: \(movie.releaseDate ?? "")")
                    .font(.headline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .padding()
                
                
                HStack{
                    // Display the movie's rating using the RatingView.
                    Ratings(rating: movie.voteAverage ?? 0)
                        .padding()
                    // display if the movie is favorite or not
                    Image(systemName:isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                    
                    
                }
                Button(action: {
                    self.showReviewView = true
                }) {
                    Text("Reviews")
                }
                .sheet(isPresented: $showReviewView) {
                    ReviewView(movie:String(movie.id))
                }.foregroundColor(.red).fontWeight(.semibold)
                    .font(.custom("Avenir",size:20))
                    .fontWeight(.bold)
                
                // Display the movie's overview.
                Text(movie.overview ?? "")
                    .font(.custom("Gotham", size: 15)).fontWeight(.light)
                    .multilineTextAlignment(.leading)
                    .padding()
                
                Spacer()
                
            }
        }
        // Load the movie images when the view appears.
        .onAppear {
            fetchMovieImages(for: movie.id) { result in
                switch result {
                case .success(let images):
                    movieImages = images
                case .failure(let error):
                    print("Error while fetching images of ", error)
                }
            }
        }
    }
}


// This is the preview provider for the MovieDetailView
struct MovieDetailView_Previews: PreviewProvider {
    static let movie = Movie(id: 1, title: "The Shawshank Redemption", overview: "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.", posterPath: "1994-09-23", backDropPath: "/9O7gLzmreU0nGkIB6K3BsJbzvNv.jpg", releaseDate: "/xBKGJQsAIeweesB79KC89FpBrVr.jpg", voteAverage: 8.7,voteCount: 1234)
    
    static var previews: some View {
        DetailedMovieView(movie: movie,isFavorite: true)
    }
}

// This function fetches movie images for a given movie ID and returns the result through a completion handler.
func fetchMovieImages(for movieID: Int, completion: @escaping (Result<[MovieImage], Error>) -> Void) {
    // API key for accessing the movie database.
    let apiKey = "2fc0945fd103aed69171f05997ba53f7"
    //URL for the movie images API with the given movie ID and API key.
    let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/images?api_key=\(apiKey)")!
    
    // Call the 'fetchData' function passing the URL and a completion handler.
    fetchData(from: url) { result in
        switch result {
        case .success(let data):
            do {
                let response = try JSONDecoder().decode(MovieImagesResponse.self, from: data)
                // Map the fetched response object to an array of 'MovieImage' objects and pass it to the completion handler
                let allImages = response.backdrops.map { MovieImage(filePath: $0.filePath) }
                completion(.success(allImages))
            } catch {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

// This function fetches data from the given URL and passes the result to a completion handler
func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            let error = NSError(domain: "com.example.fetchData",
                                code: statusCode,
                                userInfo: [NSLocalizedDescriptionKey: "Unexpected server response"])
            completion(.failure(error))
            return
        }
        // If data is received, pass it to the completion handler
        guard let data = data else {
            let error = NSError(domain: "com.example.fetchData",
                                code: -1,
                                userInfo: [NSLocalizedDescriptionKey: "Data not received"])
            completion(.failure(error))
            return
        }
        completion(.success(data))
    }
    // Start the data task
    task.resume()
}


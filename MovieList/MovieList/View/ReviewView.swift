//
//  ReviewView.swift
//  MovieList
//
//  Created by Devika Shendkar on 5/1/23.
//

import SwiftUI
import Firebase

struct ReviewView: View {
    var movie: String
    @State private var rating = 10
    @State private var text = ""
    @State private var userName: String?

    // Create a StateObject to hold the ViewModel that will manage the reviews for this movie
    @StateObject private var viewModel: ReviewModel

    // Initialize the view with the given movie ID and create the ReviewViewModel
    init(movie: String) {
        self.movie = movie
        self._viewModel = StateObject(wrappedValue: ReviewModel(movieId: movie))
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Write a Review").foregroundColor(.black)) {
                    HStack {
                        Text("Rating:").foregroundColor(.black)
                        Spacer()
                        Stepper(value: $rating, in: 1...10) {
                            Text("\(rating)").foregroundColor(.black)
                        }
                    }
                    TextEditor(text: $text)
                        .frame(height: 100)
                    Button(action: addReview) {
                        Text("Submit")
                            .bold()
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(.red)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                }
                
                // Show a list of reviews for this movie
                Section(header: Text("Reviews").foregroundColor(.black)) {
                    ForEach(viewModel.reviews) { review in
                        VStack(alignment: .leading) {
                            // Display the review's rating using a custom view
                            Ratings(rating: Double(review.rating))
                            
                            Spacer()
                            
                            // Display the review's text
                            Text(review.text)
                            
                            // Display the review's creation date
                            Text(review.createdAt, style: .date)
                                .foregroundColor(.secondary)
                                .font(.custom( "Avenir", size: 12))
                            
                            // Add buttons to allow users to like or dislike a review
                            HStack {
                                Button(action: {
                                    viewModel.likeReview(review)
                                }) {
                                    VStack {
                                        Image(systemName: "hand.thumbsup.fill")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.blue)
                                        Text("\(review.likes)")
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                    }
                                }
                                Button(action: {
                                    viewModel.dislikeReview(review)
                                }) {
                                    VStack {
                                        Image(systemName: "hand.thumbsdown.fill")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.red)
                                        Text("\(review.dislikes)")
                                            .font(.caption)
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            
                            // Display the review's author and optionally allow the user to delete their own review
                            HStack {
                                Text("By \(review.name)")
                                    .foregroundColor(.secondary)
                                    .font(.custom( "Avenir", size: 16))
                                Spacer()
                                if review.ownerId == Auth.auth().currentUser?.uid {
                                    Button(action: {
                                        viewModel.deleteReview(review)
                                    }) {
                                        Image(systemName: "trash")
                                        //Text("Delete")
                                    }
                                    .foregroundColor(.red)
                                }
                            }//.padding(10)
                        }
                    }
                }.padding(5)
                .navigationTitle("Reviews")
              
            }
            .onAppear {
                // When the view appears, attempt to get the user's name and store it in a State variable
                viewModel.getUserName(for: Auth.auth().currentUser?.uid ?? "") { name in
                    self.userName = name
                }
            }
        }
    }
    // Add a new review using the current rating, text, and username (or "Anonymous" if no username is available)
        private func addReview() {
            
            viewModel.addReview(rating: rating, text: text, name: userName ?? "Anonymous",ownerId: Auth.auth().currentUser?.uid ?? "")
            
            rating = 10
            text = ""
        }
    }


struct ReviewsView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(movie:"123")
    }
}

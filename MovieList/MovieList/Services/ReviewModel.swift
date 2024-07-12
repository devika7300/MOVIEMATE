//
//  ReviewModel.swift
//  MovieList
//
//  Created by Devika Shendkar on 5/1/23.
//

import Foundation
import Firebase

class ReviewModel: ObservableObject {
    
    // Published property to observe changes to the reviews array
    @Published var reviews = [Review]()
    
    // Reference to the Firebase Realtime Database instance
    private let db = Database.database().reference().child("reviews")
    
    // Movie ID for which the reviews are being fetched
    private let movieId: String
    
    // Reference to the users node in the database
    private let usersRef = Database.database().reference().child("users")
    
    // Initializes the view model with a movie ID
    init(movieId: String) {
        self.movieId = movieId
        
        // Fetches the reviews for the given movie ID from the database and updates the reviews array
        let movieReviewsRef = db.child(movieId)
        movieReviewsRef.observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else { return }
            self.reviews = value.compactMap { (key, data) in
                guard let reviewData = try? JSONSerialization.data(withJSONObject: data),
                      let review = try? JSONDecoder().decode(Review.self, from: reviewData) else { return nil }
                return review
            }
        }
    }
    
    // Adds a new review to the database for the given movie ID
    func addReview(rating: Int, text: String, name: String, ownerId: String) {
        let review = Review(rating: rating, text: text, name: name, ownerId: ownerId)
        let reviewData = try? JSONEncoder().encode(review)
        db.child(movieId).child(review.id).setValue(try? JSONSerialization.jsonObject(with: reviewData ?? Data()))
    }
    
    // Increases the like count of the given review in the database
    func likeReview(_ review: Review) {
        var updatedReview = review
        updatedReview.like()
        let reviewData = try? JSONEncoder().encode(updatedReview)
        db.child("/\(movieId)/\(review.id)").setValue(try? JSONSerialization.jsonObject(with: reviewData ?? Data()))
    }
    
    // Increases the dislike count of the given review in the database
    func dislikeReview(_ review: Review) {
        var updatedReview = review
        updatedReview.dislike()
        let reviewData = try? JSONEncoder().encode(updatedReview)
        db.child("/\(movieId)/\(review.id)").setValue(try? JSONSerialization.jsonObject(with: reviewData ?? Data()))
    }
    
    // Deletes the given review from the database
    func deleteReview(_ review: Review) {
        let db = Database.database().reference()
        db.child("reviews").child(movieId).child(review.id).removeValue()
    }
    
    // Fetches the name of the user with the given user ID from the database
    func getUserName(for userID: String, completion: @escaping (String?) -> Void) {
        usersRef.child(userID).child("name").observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.value as? String)
        }
    }
}

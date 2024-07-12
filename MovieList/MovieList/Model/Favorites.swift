//
//  Favorites.swift
//  MovieList
//
//  Created by Devika Shendkar on 4/17/23.
//

import Foundation
struct Favorites {
    var movies: [Movie] = [] // An array of Movie objects to store the user's favorite movies
    
    // Adds a movie to the favorite list
    mutating func add(movie: Movie) {
        movies.append(movie)
    }
    
    // Removes a movie from the favorite list
    mutating func remove(movie: Movie) {
        if let index = movies.firstIndex(of: movie) {
            movies.remove(at: index)
        }
    }
    
    // Checks if a movie is already in the favorite list
    func contains(movie: Movie) -> Bool {
        movies.contains(movie)
    }
}

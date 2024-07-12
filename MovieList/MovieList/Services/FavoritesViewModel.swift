//
//  FavoritesViewModel.swift
//  MovieList
//
//  Created by Devika Shendkar on 4/17/23.
//

import Foundation
// This class is responsible for managing the user's favorite movie list
class FavoriteViewModel: ObservableObject {
    // The favoriteList property holds the current user's favorite movie list
    @Published var favoriteList = Favorites()
    
    // The toggleFavorite method adds or removes a movie from the favorite list depending on whether it's already in the list or not
    func toggleFavorite(movie: Movie) {
        if favoriteList.contains(movie: movie) {
            favoriteList.remove(movie: movie)
        } else {
            favoriteList.add(movie: movie)
        }
    }
    
    // The isFavorite method checks whether a movie is already in the favorite list or not
    func isFavorite(movie: Movie) -> Bool {
        favoriteList.contains(movie: movie)
    }
}

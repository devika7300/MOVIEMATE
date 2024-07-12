//
//  Movie.swift
//  MovieList
//
//  Created by Devika Shendkar on 4/17/23.
//

import Foundation
// Movie model that depicts the TMDB app's answer for various movie categories.
struct Movie: Decodable, Identifiable, Hashable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
    let backDropPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    let voteCount: Int?

    //let genreIds: [MovieGenre]?
    
    var posterURL: URL {
           return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
       }
    
    var backdropURL: URL {
           return URL(string: "https://image.tmdb.org/t/p/w500\(backDropPath ?? "")")!
       }
    
  
}

struct MovieGenre: Decodable {
    
    let name: String
}

struct MovieResponse: Decodable {
    
    let results: [Movie]
}




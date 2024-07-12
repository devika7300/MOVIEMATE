//
//  Protocol.swift
//  MovieList
//
//  Created by Devika Shendkar on 4/17/23.
//

import Foundation
//protocol which defines function used to fetch the movies info from TMDB for all categories
protocol ProtocolMovie {
    
    func fetchMovies(from endpoint: MovieListEndpoint) async throws -> [Movie]
}

//enum for differnet movie categories
enum MovieListEndpoint: String, CaseIterable, Identifiable {
    
    var id: String { rawValue }
    
    case nowPlaying = "now_playing"
    case upcoming = "upcoming"
    case topRated = "top_rated"
    case popular = "popular"
    
    var description: String {
        switch self {
            case .nowPlaying: return "Now Playing"
            case .upcoming: return "Upcoming"
            case .topRated: return "Top Rated"
            case .popular: return "Popular"
        }
    }
}

//enum for differnet error categories
enum MovieError: Error, CustomNSError {
    
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        }
    }
    
}

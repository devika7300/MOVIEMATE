//
//  FetchMovies.swift
//  MovieList
//
//  Created by Devika Shendkar on 4/17/23.
//

import Foundation
class FetchMovie: ObservableObject {
    
    private let movieService: ProtocolMovie = ImplementMovie.shared
    @Published var nowPlayingmovies = [Movie]()
    @Published var upcomingMovies = [Movie]()
    @Published var topRatedMovies = [Movie]()
    @Published var popularMovies = [Movie]()
    let service: ProtocolMovie
    
    //An initializer is defined to retrieve movies from various endpoints and initialize the service property with the default MovieImplement instance.

    init(service: ProtocolMovie = ImplementMovie()) {
        self.service = service
        Task    {
            await fetchNowPlayigMoviesFromEndpoint(.nowPlaying)
            await fetchUpcomingFromEndpoint(.upcoming)
            await fetchTopRatedFromEndpoint(.topRated)
            await fetchPopularFromEndpoint(.popular)
        
        }
    }
    
    // asynchronous functions that use the movieService instance to fetch now playing movies
   @Sendable
    func fetchNowPlayigMoviesFromEndpoint(_ endpoint: MovieListEndpoint) async -> Void {
        do {
            let movies = try await movieService.fetchMovies(from: endpoint)
            DispatchQueue.main.async {
                self.nowPlayingmovies.append(contentsOf: movies)
                print("now playing movies")
                print(self.nowPlayingmovies)
            }
        } catch {
            print("Error")
        }
    }
    
    // asynchronous functions that use the movieService instance to fetch upcoming movies
    @Sendable
     func fetchUpcomingFromEndpoint(_ endpoint: MovieListEndpoint) async -> Void {
         do {
             let movies = try await movieService.fetchMovies(from: endpoint)
             DispatchQueue.main.async {
                 self.upcomingMovies.append(contentsOf: movies)
                 print("upcoming movies")
                 print(self.upcomingMovies)
             }
         } catch {
             print("Error")
         }
     }
    
    // asynchronous functions that use the movieService instance to fetch top rated movies
    @Sendable
     func fetchTopRatedFromEndpoint(_ endpoint: MovieListEndpoint) async -> Void {
         do {
             let movies = try await movieService.fetchMovies(from: endpoint)
             DispatchQueue.main.async {
                 self.topRatedMovies.append(contentsOf: movies)
                 print("top rated movies")
                 print(self.topRatedMovies)
             }
         } catch {
             print("Error")
         }
     }
    
    // asynchronous functions that use the movieService instance to fetch popular movies
    @Sendable
     func fetchPopularFromEndpoint(_ endpoint: MovieListEndpoint) async -> Void {
         do {
             let movies = try await movieService.fetchMovies(from: endpoint)
             DispatchQueue.main.async {
                 self.popularMovies.append(contentsOf: movies)
                 print("popular movies")
                 print(self.popularMovies)
             }
         } catch {
             print("Error")
         }
     }
    
    

}

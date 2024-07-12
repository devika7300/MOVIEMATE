//
//  ImplementMovie.swift
//  MovieList
//
//  Created by Devika Shendkar on 4/17/23.
//

import Foundation
import SwiftUI


class ImplementMovie: ProtocolMovie {
    
    static let shared = ImplementMovie()
    public init() {}
    //API key used to access The Movie DB API
    private let apiKey = "2fc0945fd103aed69171f05997ba53f7"
    //base URL of The Movie DB API
    private let baseAPIURL = "https://api.themoviedb.org/3/movie"
    //bearer token used to authenticate the API request
    private let bearToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhN2NmNWNjMjMyYjAzYjk3YjMwYjkwNjRlZjNmNmVhOSIsInN1YiI6IjY0MjVkOTNjNjkwNWZiMDEyNjA4NzgwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.sRlPpCkHclZPlHE460KmqHe6ALgfbT2K720dPd_b_i8"
    private let urlSession = URLSession.shared
    private let jsonDecoder = Utility.jsonDecoder
    
    // This function takes a MovieListEndpoint and returns an array of Movie objects
    func fetchMovies(from endpoint: MovieListEndpoint) async throws -> [Movie] {
        guard let url = URL(string: "\(baseAPIURL)/\(endpoint.rawValue)") else {
            throw MovieError.invalidEndpoint
        }
        // This creates a MovieResponse object by making the API request and decoding the JSON response
        let movieResponse: MovieResponse = try await self.loadURLAndDecode(url: url)
        // This returns an array of Movie objects from the MovieResponse object
        return movieResponse.results
    }
    
    // This is a private helper function that loads a URL and decodes the JSON response
    private func loadURLAndDecode<D: Decodable>(url: URL, params: [String: String]? = nil) async throws -> D {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw MovieError.invalidEndpoint
        }
        // This adds the API key as a URLQueryItem to the URLComponents object
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        // This adds any additional parameters passed in as a parameter to the URLComponents object as URLQueryItems
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        urlComponents.queryItems = queryItems
        // This creates a final URL
        guard let finalURL = urlComponents.url else {
            throw MovieError.invalidEndpoint
        }
        
        var request = URLRequest(url: finalURL)
        request.setValue(bearToken, forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw MovieError.invalidResponse
        }
        
        return try self.jsonDecoder.decode(D.self, from: data)
    }


}

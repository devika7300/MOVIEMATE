//
//  Review.swift
//  MovieList
//
//  Created by Devika Shendkar on 5/1/23.
//

import Foundation
struct Review: Identifiable, Codable {
    let id: String
    let rating: Int
    let text: String
    let name: String
    let createdAt: Date
    var likes: Int
    var dislikes: Int
    let ownerId: String
    
    init(rating: Int, text: String, name: String,ownerId: String, likes: Int = 0, dislikes: Int = 0) {
        self.id = UUID().uuidString
        self.rating = rating
        self.text = text
        self.name = name
        self.ownerId = ownerId
        self.createdAt = Date()
        self.likes = likes
        self.dislikes = dislikes
    }
    
    mutating func like() {
        likes += 1
    }
    
    mutating func dislike() {
        dislikes += 1
    }
}

//
//  Ratings.swift
//  MovieList
//
//  Created by Devika Shendkar on 4/17/23.
//

import Foundation
import SwiftUI

//Defining the view which responds with the rating image
struct Ratings: View {
    var rating: Double
    
    var body: some View {
        HStack {
            ForEach(1..<11) { index in
                // Adding an image view with the "systemName" property set to either "star.fill" or "star" based on the comparison between the index and rating
                Image(systemName: index <= Int(rating) ? "star.fill" : "star")
                    .foregroundColor(index <= Int(rating) ? .yellow : .gray)
            }
        }
    }
}


struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        Ratings(rating: 4.5)
    }
}



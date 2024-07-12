//
//  Utility.swift
//  MovieList
//
//  Created by Devika Shendkar on 4/17/23.
//

import Foundation
class Utility {
    
    static let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        jsonDecoder.userInfo[.isFavorite] = true // set the user info key to true
        return jsonDecoder
    }()
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter
    }()
    
   
}

extension CodingUserInfoKey {
    static let isFavorite = CodingUserInfoKey(rawValue: "isFavorite")!
}

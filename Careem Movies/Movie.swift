//
//  Movie.swift
//  Careem Movies
//
//  Created by Jan G. Botros on 7/27/18.
//  Copyright © 2018 Jan G. Botros. All rights reserved.
//

import Foundation

struct Movie {
    var vote_count: Int
    var id: Int
    var vote_average: Double
    var title: String
    var popularity: Double
    var poster_path: String
    var original_language: String
    var original_title: String
    var adult: Bool
    var overview: String
    var release_date: String
    
    init?(dictionary: Dictionary<String, Any>) {
        guard
            let vote_count = dictionary["vote_count"] as? Int,
            let id = dictionary["id"] as? Int,
            let vote_average = dictionary["vote_average"] as? Double,
            let title = dictionary["title"] as? String,
            let popularity = dictionary["popularity"] as? Double,
            let poster_path = dictionary["poster_path"] as? String,
            let original_language = dictionary["original_language"] as? String,
            let original_title = dictionary["original_title"] as? String,
            let adult = dictionary["adult"] as? Bool,
            let overview = dictionary["overview"] as? String,
            let release_date = dictionary["release_date"] as? String
            
            else {
                return nil
        }
        self.vote_count = vote_count
        self.id = id
        self.vote_average = vote_average
        self.title = title
        self.popularity = popularity
        self.poster_path = poster_path
        self.original_language = original_language
        self.original_title = original_title
        self.adult = adult
        self.overview = overview
        self.release_date = release_date
    }
}

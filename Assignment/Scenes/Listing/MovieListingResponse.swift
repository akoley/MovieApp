//
//  MovieListingResponse.swift
//  Assignment
//
//  Created by Amrita Koley on 9/16/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import Foundation
import ObjectMapper

struct MovieListingResponse: Mappable {
    var page = 0
    var totalResults = 0
    var totalPages = 0
    var results: [MovieListingDetails] = []
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        page <- map["page"]
        totalResults <- map["total_results"]
        totalPages <- map["total_pages"]
        results <- map["results"]
        
    }
}

struct MovieListingDetails: Mappable {
    private(set) var voteCount = 0
    private(set) var id: Int?
    private(set) var video = false
    private(set) var voteAverage = 0.0
    private(set) var title: String?
    private(set) var popularity = 0.0
    private(set) var posterPath: String?
    private(set) var originalLanguage: String?
    private(set) var originalTitle: String?
    private(set) var genreIDs: [Int] = []
    private(set) var backdropPath: String?
    private(set) var adult = false
    private(set) var overview: String?
    private(set) var releaseDate: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        voteCount <- map["vote_count"]
        id <- map["id"]
        video <- map["video"]
        voteAverage <- map["vote_average"]
        title <- map["title"]
        popularity <- map["popularity"]
        posterPath <- map["poster_path"]
        originalLanguage <- map["original_language"]
        originalTitle <- map["original_title"]
        genreIDs <- map["genre_ids"]
        backdropPath <- map["backdrop_path"]
        adult <- map["adult"]
        overview <- map["overview"]
        releaseDate <- (map["release_date"], StringToDateTransform())
        
    }
}

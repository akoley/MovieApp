//
//  MovieListingCellViewModel.swift
//  Assignment
//
//  Created by Amrita Koley on 9/17/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import UIKit

protocol MovieListingCellViewModelProtocol {
    var name: String? { get set }
    var subName: String? { get set }
    var imageUrl: URL? { get set }
}

struct MovieListingCellViewModel: MovieListingCellViewModelProtocol {
    var name: String?
    var subName: String?
    var imageUrl: URL?
    
    init(movie: MovieListingDetails) {
        name = movie.title
        subName = movie.releaseDate
        if let image = movie.posterPath {
            imageUrl = URL(string: Constants.Api.imageBaseURL + "/t/p/w92/" + image)
        }
    }
}


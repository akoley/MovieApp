//
//  MovieListingViewModel.swift
//  Assignment
//
//  Created by Amrita Koley on 9/16/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import Foundation
import RxSwift

protocol MovieListingViewModelProtocol: class {
    var searchResultsObservable: Observable<[MovieListingCellViewModel]> { get }
    var searchTerm: String? {get set}
    var loadPage: PublishSubject<Int> { get }
    var addToRecentlySearched: PublishSubject<String> { get }
    var movieSelected: PublishSubject<MovieListingDetails> { get }
    var itemSelected: PublishSubject<IndexPath> { get }
    func getMovies(query: String, page: Int)
}

class MovieListingViewModel: MovieListingViewModelProtocol {
    var searchResultsObservable: Observable<[MovieListingCellViewModel]>
    let loadPage = PublishSubject<Int>()
    let addToRecentlySearched = PublishSubject<String>()
    let itemSelected = PublishSubject<IndexPath>()
    let movieSelected = PublishSubject<MovieListingDetails>()
    var movieListingResponse: MovieListingResponse?
    var data = Variable<[MovieListingCellViewModel]>([])
    var searchTerm: String?
    let disposeBag = DisposeBag()
    let searchResultsResponse = Variable<[MovieListingCellViewModel]>([])
    
    init() {
        searchResultsObservable = searchResultsResponse.asObservable()
        loadPage.subscribe(onNext: {[weak self] page in
            guard let `self` = self, let searchTerm = self.searchTerm else { return }
            `self`.getMovies(query: searchTerm, page: page)
            
        }).disposed(by: disposeBag)
        itemSelected
            .map { [weak self] in self?.movieListingResponse?.results[$0.row]}
            .subscribe(onNext: { [weak self] movie in
                guard let `self` = self, let movie = movie else { return }
                `self`.movieSelected.onNext(movie)
            })
            .disposed(by: disposeBag)
    }
    
    func getMovies(query: String, page: Int) {
        searchTerm = query
        APIClient.getSearchResults(searchTerm: query, page: page) { [weak self] result in
            switch result {
            case let .success(response):
                if response.results.isEmpty == false {
                    self?.movieListingResponse = response
                    self?.addToRecentlySearched.onNext(query)
                    if page <= 1 {
                        self?.searchResultsResponse.value = []
                    }
                    self?.searchResultsResponse.value += response.results.map({ (movie) -> MovieListingCellViewModel in
                        MovieListingCellViewModel(movie: movie)
                    })
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}


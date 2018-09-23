//
//  MovieListingViewModel.swift
//  Assignment
//
//  Created by Amrita Koley on 9/16/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

protocol MovieListingViewModelProtocol: class {
    var searchResultsObservable: Observable<[MovieListingCellViewModel]> { get }
    var searchTerm: String? {get set}
    var loadPage: PublishSubject<Int> { get }
    var addToRecentlySearched: PublishSubject<String> { get }
    var movieSelected: PublishSubject<MovieListingDetails> { get }
    var itemSelected: PublishSubject<IndexPath> { get }
    var errorObservable: PublishSubject<ErrorPageData> { get }
    
    func getMovies(query: String, page: Int)
}

class MovieListingViewModel: MovieListingViewModelProtocol {
    let disposeBag = DisposeBag()
    var errorObservable = PublishSubject<ErrorPageData>()
    var searchResultsObservable: Observable<[MovieListingCellViewModel]>
    let loadPage = PublishSubject<Int>()
    let addToRecentlySearched = PublishSubject<String>()
    let itemSelected = PublishSubject<IndexPath>()
    let movieSelected = PublishSubject<MovieListingDetails>()
    var movieListingResponse: MovieListingResponse?
    let searchResultsResponse = Variable<[MovieListingCellViewModel]>([])
    
    internal var searchTerm: String?
    private var currentPage = 0
    private var _request : Request!
    
    init() {
        searchResultsObservable = searchResultsResponse.asObservable()
        loadPage.subscribe(onNext: {[weak self] page in
            guard let `self` = self else { return }
            `self`.currentPage = page
            `self`.getListingInfo()
        }).disposed(by: disposeBag)
        itemSelected
            .map { [weak self] in self?.movieListingResponse?.results[$0.row]}
            .subscribe(onNext: { [weak self] movie in
                guard let `self` = self, let movie = movie else { return }
                `self`.movieSelected.onNext(movie)
            })
            .disposed(by: disposeBag)
    }
    
    func getListingInfo() {
        if movieListingResponse != nil
            && searchResultsResponse.value.count >= (movieListingResponse?.totalResults)! {
            return
        }
        
        if(_request != nil) {
            _request.cancel()
            _request = nil
        }
        
        if searchTerm?.isEmpty == false {
            getMovies(query: searchTerm!, page: currentPage)
        }
    }
    
    private func convertResponseToMovieResponse(response: MovieListingResponse) {
        if movieListingResponse != nil {
            movieListingResponse?.page = response.page
            movieListingResponse?.results += response.results
        } else {
            movieListingResponse = response
        }
    }
    
    func getMovies(query: String, page: Int) {
        searchTerm = query
        currentPage = page
        APIClient.getSearchResults(searchTerm: query, page: page) { [weak self] result in
            switch result {
            case let .success(response):
                if response.results.isEmpty == false {
                    self?.convertResponseToMovieResponse(response: response)
                    self?.addToRecentlySearched.onNext(query)
                    if page <= 1 {
                        self?.searchResultsResponse.value = []
                    }
                    self?.searchResultsResponse.value += response.results.map({ (movie) -> MovieListingCellViewModel in
                        MovieListingCellViewModel(movie: movie)
                    })
                } else {
                    self?.searchResultsResponse.value = []
                    let errorData = ErrorPageData.init(
                        errorMessage: Constants.StringConstants.NoResults
                            + "\'" + query + "\'",
                        errorImage: nil,
                        shouldShowRetryButton: false,
                        shouldShowMessage: true)
                    self?.errorObservable.onNext(errorData)
                }
            case let .failure(error):
                self?.searchResultsResponse.value = []
                let errorData = ErrorPageData.init(
                    errorMessage: error.localizedDescription,
                    errorImage: Constants.ImageAssets.noNetwork.image,
                    shouldShowRetryButton: true,
                    shouldShowMessage: true)
                self?.errorObservable.onNext(errorData)
            }
        }
    }
}


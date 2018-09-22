//
//  SearchViewModel.swift
//  Assignment
//
//  Created by Amrita Koley on 9/16/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum SearchStatus {
    case recent
    case suggestions
    case loading
    case results
}

protocol SearchViewModelProtocol {
    var status: SearchStatus { get set }
    var searchSuggestionsVM: SearchSuggestionsViewModelProtocol? { get set }
    var searchResultsVM: MovieListingViewModelProtocol? { get set }
    
    func queryChanged(query: String)
    func performSearch(query: String)
    func searchCancelled()
}

protocol SearchViewDelegate: class {
    func statusChanged()
}

protocol SearchOutputDelegate: class {
    func movieSelected(movie: MovieListingDetails)
    func searchCancelled()
}

class SearchViewModel: SearchViewModelProtocol {
    weak var searchSuggestionsVM: SearchSuggestionsViewModelProtocol?
    weak var searchResultsVM: MovieListingViewModelProtocol?
    weak var viewDelegate: SearchViewDelegate?
    weak var outputDelegate: SearchOutputDelegate?
    
    let disposeBag = DisposeBag()
    
    var status = SearchStatus.recent {
        didSet {
            if oldValue != status {
                pageStatusChanged()
            }
        }
    }
    
    init(searchSuggestionsVM: SearchSuggestionsViewModelProtocol,
         searchResultsVM: MovieListingViewModelProtocol) {
        self.searchSuggestionsVM = searchSuggestionsVM
        self.searchResultsVM = searchResultsVM
        
        searchResultsVM.addToRecentlySearched.subscribe(
            onNext: { [weak self] (searchTerm) in
                self?.updateRecentlySearchedTerms(query: searchTerm)
        }).disposed(by: disposeBag)
        
        searchSuggestionsVM.suggestionSelected
            .subscribe(onNext: { [weak self] suggestion in
                guard let `self` = self else { return }
                `self`.performSearch(query: suggestion)
        }).disposed(by: disposeBag)
        
//        searchSuggestionsVM.suggestionSelected.subscribe(
//            onNext: { [weak self] (suggestion) in
//            guard let `self` = self, let suggestion = suggestion else { return }
//            `self`.performSearch(query: sug) suggestionSelected.onNext(suggestion)
//            self?.performSearch(query: suggestion)
//        }).disposed(by: disposeBag)
        
        searchResultsVM.movieSelected.subscribe(onNext: {[weak self] (movieInfo) in
            print("I just got tapped")
        }).disposed(by: disposeBag)
        
        
    }
    
    func pageStatusChanged() {
        viewDelegate?.statusChanged()
    }
    
    func didTapOnSearchBar() {
        status = .suggestions
        searchSuggestionsVM?.getRecentlySearchedTerms()
    }
    
    func updateRecentlySearchedTerms(query: String) {
        searchSuggestionsVM?.updateRecentlySearchedTerms(query: query)
    }
    
    func queryChanged(query: String) {
        status = .suggestions
        searchSuggestionsVM?.queryChanged(query: query)
    }
    
    func performSearch(query: String) {
        status = .results
        searchResultsVM?.getMovies(query: query, page: 1)
    }
    
    func searchCancelled() {
        outputDelegate?.searchCancelled()
    }
}

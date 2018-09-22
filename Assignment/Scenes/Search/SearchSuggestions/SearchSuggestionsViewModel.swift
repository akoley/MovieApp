//
//  SearchSuggestionsViewModel.swift
//  Assignment
//
//  Created by Amrita Koley on 9/16/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import RxSwift
import UIKit

protocol SearchSuggestionsViewModelProtocol: class {
    var suggestionsObservable: Observable<[String]> { get }
    var addToRecentlySearched: PublishSubject<String> { get }
    var suggestionSelected: PublishSubject<String> { get }
    var itemSelected: PublishSubject<IndexPath> { get }
    func getRecentlySearchedTerms()
    func queryChanged(query: String)
    func updateRecentlySearchedTerms(query: String)
}

class SearchSuggestionsViewModel: SearchSuggestionsViewModelProtocol {
    
    private let searchSuggestions = Variable<[String]>([])
    let addToRecentlySearched = PublishSubject<String>()
    let suggestionSelected = PublishSubject<String>()
    let itemSelected = PublishSubject<IndexPath>()
    let suggestionsObservable: Observable<[String]>
    let disposeBag = DisposeBag()
    init() {
        suggestionsObservable = searchSuggestions.asObservable()
        
        itemSelected
            .map { [weak self] in self?.searchSuggestions.value[$0.row] }
            .subscribe(onNext: { [weak self] suggestion in
                guard let `self` = self, let suggestion = suggestion else { return }
                `self`.suggestionSelected.onNext(suggestion)
            })
            .disposed(by: disposeBag)
    }
    
    func getRecentlySearchedTerms() {
        let coreDataHandler = CoreDataHandler.getSharedInstance()
        searchSuggestions.value = coreDataHandler.fetchRecentSearchTerms(
                inReverseOrder: false)
        
    }
    
    func updateRecentlySearchedTerms(query: String) {
        //Enter search term to the database only when it fetches a valid response
        
        let coreDataHandler = CoreDataHandler.getSharedInstance()
        var recentSearchedTerms = coreDataHandler.fetchRecentSearchTerms(
            inReverseOrder: true)
        for recentSearchTerm in recentSearchedTerms {
            if recentSearchTerm.caseInsensitiveCompare(query) == ComparisonResult.orderedSame {
                if let index = recentSearchedTerms.index(of: recentSearchTerm) {
                    recentSearchedTerms.remove(at: index)
                    coreDataHandler.deleteRecentSearchTerm(searchTerm: query)
                }
            }
        }
        coreDataHandler.insertRecentSearchTerm(searchTerm: query)
    }
    
    func queryChanged(query: String) {
        
//        APIClient.getSearchSuggestions(query: query) { [weak self] result in
//            switch result {
//            case let .success(response):
//                self?.searchSuggestions.value = response.data?.suggestions ?? []
//            case let .failure(error):
//                print(error.localizedDescription)
//            }
//        }
    }
}

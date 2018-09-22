//
//  SearchCoordinator.swift
//  Assignment
//
//  Created by Amrita Koley on 9/16/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import UIKit

class SearchCoordinator: Coordinator<DeepLink> {
    let searchViewController: SearchViewController
    
    override init(router: RouterType) {
        
        let searchSuggestionVM = SearchSuggestionsViewModel()
        let searchSuggestionVC = SearchSuggestionsTableViewController.instantiate(viewModel: searchSuggestionVM)
        
        let searchResultsVC = MovieListingViewController(nibName: "MovieListingViewController", bundle: nil)
        let searchResultsVM = MovieListingViewModel()
        searchResultsVC.viewModel = searchResultsVM
        
        let searchVM = SearchViewModel(searchSuggestionsVM: searchSuggestionVM, searchResultsVM: searchResultsVM)
        searchViewController = SearchViewController.instantiate(suggestionsView: searchSuggestionVC,
                                                                searchResultsView: searchResultsVC,
                                                                searchVM: searchVM)
        searchVM.viewDelegate = searchViewController
        
        super.init(router: router)
        
        searchVM.outputDelegate = self
    }
    
    override func start() {}
    
    override func toPresentable() -> UIViewController {
        return searchViewController
    }
}

extension SearchCoordinator: SearchOutputDelegate {
    func movieSelected(movie _: MovieListingDetails) {
        print("I just got tapped")
    }
    
    func searchCancelled() {
        print("Search is cancelled")
        router.popModule(animated: true)
        
    }
}


//
//  SearchViewController.swift
//  Assignment
//
//  Created by Amrita Koley on 9/16/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class SearchViewController: UIViewController {
    var viewModel: SearchViewModel!
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var searchBar: UISearchBar!
    var suggesions: [String] = []
    var suggestionsView: UIViewController!
    var searchResultsView: UIViewController!
    
    private let bag = DisposeBag()
    
    static func instantiate(suggestionsView: UIViewController,
                            searchResultsView: UIViewController,
                            searchVM: SearchViewModel) -> SearchViewController {
        let viewController = UIStoryboard
            .search
            .instantiateViewController(withIdentifier: SearchViewController.className)
            // swiftlint:disable:next force_cast
            as! SearchViewController
        viewController.suggestionsView = suggestionsView
        viewController.searchResultsView = searchResultsView
        viewController.viewModel = searchVM
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = Constants.StringConstants.Search
        bindUI()
    }
    
    func bindUI() {
        
        searchBar.rx
            .textDidBeginEditing
            .asObservable()
            .subscribe(onNext: { [weak self] query in
            self?.viewModel.didTapOnSearchBar()
        }).disposed(by: bag)
        
        searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .filter { query in
                query.count > 2
            }
            .debounce(0.5, scheduler: MainScheduler.instance)
            .asObservable()
            .subscribe(onNext: { [weak self] query in
                self?.viewModel.queryChanged(query: query)
            }).disposed(by: bag)
        
        searchBar.rx.searchButtonClicked.subscribe(onNext: { [weak self] () in
            self?.viewModel.performSearch(query: self!.searchBar.text!)
            self?.view.endEditing(true)
        }).disposed(by: bag)
        
        searchBar.rx.cancelButtonClicked.subscribe(onNext: { [weak self] () in
            self?.viewModel.searchCancelled()
        }).disposed(by: bag)
    }
    
    func switchTo(viewController: UIViewController) {
        guard !children.contains(viewController) else {
            containerView.bringSubviewToFront(viewController.view)
            return
        }
        addChild(viewController)
        
        // make sure that the child view controller's view is the right size
        viewController.view.frame = containerView.bounds
        containerView.addSubview(viewController.view)
        
        // you must call this at the end per Apple's documentation
        viewController.didMove(toParent: self)
    }
}

extension SearchViewController: SearchViewDelegate {
    func statusChanged() {
        switch viewModel.status {
        case .loading:
            break
        case .recent:
            break
        case .results:
            view.endEditing(true)
            switchTo(viewController: searchResultsView)
        case .suggestions:
            switchTo(viewController: suggestionsView)
        }
    }
}


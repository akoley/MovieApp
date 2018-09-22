//
//  SearchSuggestionsTableViewController.swift
//  Assignment
//
//  Created by Amrita Koley on 9/16/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

class SearchSuggestionsTableViewController: UITableViewController {
    let disposeBag = DisposeBag()
    var viewModel: SearchSuggestionsViewModelProtocol!
    
    static func instantiate(viewModel: SearchSuggestionsViewModelProtocol) -> SearchSuggestionsTableViewController {
        let viewController = UIStoryboard
            .search
            .instantiateViewController(withIdentifier:
                String(describing: SearchSuggestionsTableViewController.self))
            // swiftlint:disable:next force_cast
            as! SearchSuggestionsTableViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.tableFooterView = UIView() // Prevent empty rows
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        bindUI()
    }
    
    func bindUI() {
        tableView.rx.itemSelected
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)
        
        viewModel.suggestionsObservable
            .bind(to: tableView.rx.items) { tableView, index, item in
                let indexPath = IndexPath(row: index, section: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
                cell.textLabel?.text = item
                return cell
            }
            .disposed(by: disposeBag)
    }
}


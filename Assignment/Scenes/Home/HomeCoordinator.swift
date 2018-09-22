//
//  HomeCoordinator.swift
//  Assignment
//
//  Created by Amrita Koley on 9/16/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import UIKit

class HomeCoordinator: Coordinator<DeepLink> {
    lazy var homeViewModel: HomeViewModel = {
        let viewModel = HomeViewModel(delegate: self)
        return viewModel
    }()
    
    lazy var homeViewController: HomeViewController = {
        let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        viewController?.viewModel = homeViewModel
        return viewController!
    }()
    
    override init(router: RouterType) {
        super.init(router: router)
        router.setRootModule(homeViewController, hideBar: false)
    }
}

extension HomeCoordinator: HomeVMDelegate {
    func openSearch() {
        let searchCoordinator = SearchCoordinator(router: router)
        addChild(searchCoordinator)
        searchCoordinator.start()
        router.push(searchCoordinator, animated: true) { [weak self, weak searchCoordinator] in
            self?.removeChild(searchCoordinator)
        }
    }
    
    func closeSearch() {
        router.popToRootModule(animated: true)
    }
}


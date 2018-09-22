//
//  AppCoordinator.swift
//  Assignment
//
//  Created by Amrita Koley on 9/16/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator<DeepLink>, UITabBarControllerDelegate {
    let tabBarController = UITabBarController()
    
    var tabs: [UIViewController: Coordinator<DeepLink>] = [:]
    
    lazy var homeCoordinator: HomeCoordinator = {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = UITabBarItem(title: "Home",
                                                       image: Constants.TabBarIcons.home.image,
                                                       selectedImage: Constants.TabBarIcons.home.image)
        let router = Router(navigationController: navigationController)
        let coordinator = HomeCoordinator(router: router)
        return coordinator
    }()
    
    lazy var notificationsCoordinator: HomeCoordinator = {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = UITabBarItem(title: "Notifications",
                                                       image: Constants.TabBarIcons.notification.image,
                                                       selectedImage: Constants.TabBarIcons.notification.image)
        let router = Router(navigationController: navigationController)
        let coordinator = HomeCoordinator(router: router)
        return coordinator
    }()
    
    lazy var myAccountCoordinator: HomeCoordinator = {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = UITabBarItem(title: "My Account",
                                                       image: Constants.TabBarIcons.account.image,
                                                       selectedImage: Constants.TabBarIcons.account.image)
        let router = Router(navigationController: navigationController)
        let coordinator = HomeCoordinator(router: router)
        return coordinator
    }()
    
    override init(router: RouterType) {
        super.init(router: router)
        router.setRootModule(tabBarController, hideBar: true)
        tabBarController.delegate = self
        setTabs([homeCoordinator, notificationsCoordinator, myAccountCoordinator])
    }
    
    override func start(with link: DeepLink?) {
        guard let link = link else {
            return
        }
        
        // Forward link or intercept it
        switch link {
        case .movieListing:
            // Switch to the home tab
            guard let index = tabBarController.viewControllers?.index(of: homeCoordinator.toPresentable()) else {
                return
            }
            tabBarController.selectedIndex = index
        }
    }
    
    func setTabs(_ coordinators: [Coordinator<DeepLink>], animated: Bool = false) {
        tabs = [:]
        
        // Store view controller to coordinator mapping
        let vcs = coordinators.map { coordinator -> UIViewController in
            let viewController = coordinator.toPresentable()
            tabs[viewController] = coordinator
            return viewController
        }
        
        tabBarController.setViewControllers(vcs, animated: animated)
    }
    
    // MARK: UITabBarControllerDelegate
    
    func tabBarController(_: UITabBarController, shouldSelect _: UIViewController) -> Bool {
        //        guard let coordinator = tabs[viewController] else { return true }
        
        return true
    }
    
    func tabBarController(_: UITabBarController, didSelect _: UIViewController) {}
}

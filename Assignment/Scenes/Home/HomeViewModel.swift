//
//  HomeViewModel.swift
//  Assignment
//
//  Created by Amrita Koley on 9/16/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import RxSwift

protocol HomeVMDelegate: class {
    func openSearch()
    func closeSearch()
}

class HomeViewModel {
    private weak var delegate: HomeVMDelegate?
    
    init(delegate: HomeVMDelegate) {
        self.delegate = delegate
    }
    
    func initiateSearch() {
        delegate?.openSearch()
    }
}

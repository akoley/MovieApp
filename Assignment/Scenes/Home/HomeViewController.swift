//
//  HomeViewController.swift
//  Assignment
//
//  Created by Amrita Koley on 9/16/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class HomeViewController: ViewController {
    @IBOutlet var searchBtn: UIBarButtonItem!
    var btn: UIButton!
    
    private let disposeBag = DisposeBag()
    var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
    }
    
    func setupBindings() {}
    
    @IBAction func searchBtnPressed(_: Any) {
        viewModel.initiateSearch()
    }
}


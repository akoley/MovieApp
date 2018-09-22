//
//  MovieListingViewController.swift
//  Assignment
//
//  Created by Amrita Koley on 9/16/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ListingViewController: UIViewController {
    let edgeInset: CGFloat = 10
    let interItemSpacing: CGFloat = 10
    let lineSpacing: CGFloat = 10
    let disposeBag = DisposeBag()
    
    @IBOutlet private var collectionView: UICollectionView!
    var viewModel: ProductListingViewModel!
    
    private var sizeOfProductCell = CGSize.zero
    private var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    override func loadView() {
        view = Bundle.main.loadNibNamed("ListingViewController", owner: self, options: nil)?.first as! UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initListingViewController()
    }
    
    private func initListingViewController() {
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewFlowLayout.estimatedItemSize = CGSize(width: 172.5, height: 300)
        collectionViewFlowLayout.minimumLineSpacing = lineSpacing
        collectionViewFlowLayout.minimumInteritemSpacing = interItemSpacing
        
        registerCells()
        bindUI()
    }
    
    private func registerCells() {
        collectionView.register(
            UINib(nibName: "ProductListingGridCell",
                  bundle: Bundle.main),
            forCellWithReuseIdentifier: "ProductListingGridCell")
    }
    
    private func bindUI() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.rx.itemSelected
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)
        viewModel?.searchResultsObservable.bind(to: collectionView.rx.items) { (collectionView, row, item) in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ProductListingGridCell",
                for: IndexPath(row: row, section: 0)) as! ProductListingCell
            cell.configureCell(viewModel: item)
            if row  == (self.viewModel?.searchResultsResponse.value.count)! - 20 {
                let page = (self.viewModel?.productListingResponse?.currentPage ?? 0) + 1
                self.viewModel.loadPage.onNext(page)
            }
            return cell
            }.disposed(by: disposeBag)
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension ProductListingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView,
                        layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        let sectionInset = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        return sectionInset
    }
}


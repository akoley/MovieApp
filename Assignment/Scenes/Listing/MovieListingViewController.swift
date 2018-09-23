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

class MovieListingViewController: ViewController {
    let edgeInset: CGFloat = 10
    let interItemSpacing: CGFloat = 10
    let lineSpacing: CGFloat = 10
    let disposeBag = DisposeBag()
    
    @IBOutlet private var collectionView: UICollectionView!
    var viewModel: MovieListingViewModel!
    
    private var sizeOfCell = CGSize.zero
    private var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    override func loadView() {
        view = (Bundle.main.loadNibNamed("MovieListingViewController", owner: self, options: nil)?.first as! UIView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMovieListingViewController()
    }
    
    override func showNoNetworkPrompt(_ notification: Notification!) {
        super.showNoNetworkPrompt(notification)
    }
    
    override func hideNoNetworkPrompt(_ notification: Notification!) {
        super.hideNoNetworkPrompt(notification)
    }
    
    override func _refreshButtonPressed(_ sender: AnyObject) {
        super._refreshButtonPressed(sender)
        viewModel.getListingInfo()
    }
    
    private func initMovieListingViewController() {
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionViewFlowLayout = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout)
        collectionViewFlowLayout.minimumLineSpacing = lineSpacing
        collectionViewFlowLayout.minimumInteritemSpacing = interItemSpacing
        registerCells()
        bindUI()
    }
    
    private func registerCells() {
        collectionView.register(
            UINib(nibName: "MovieListingGridCell",
                  bundle: Bundle.main),
            forCellWithReuseIdentifier: "MovieListingGridCell")
    }
    
    private func bindUI() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.rx.itemSelected
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)
        
        viewModel.errorObservable.subscribe(onNext: {[weak self] errorData in
            guard let `self` = self else { return }
            `self`.showMessage(errorData: errorData)
            
        }).disposed(by: disposeBag)
        
        viewModel?.searchResultsObservable.bind(to: collectionView.rx.items) { (collectionView, row, item) in
            self.hideMessage()
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "MovieListingGridCell",
                for: IndexPath(row: row, section: 0)) as! MovieListingCell
            cell.configureCell(viewModel: item)
            if row  == (self.viewModel?.searchResultsResponse.value.count)! - 20 {
                let page = (self.viewModel?.movieListingResponse?.page ?? 0) + 1
                self.viewModel.loadPage.onNext(page)
            }
            return cell
            }.disposed(by: disposeBag)
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension MovieListingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView,
                        layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        let sectionInset = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        return sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout _: UICollectionViewLayout,
                        sizeForItemAt _: IndexPath) -> CGSize {
        if sizeOfCell == CGSize.zero {
            sizeOfCell = MovieListingCell.getSizeOfCell(
                width: collectionView.bounds.size.width,
                isGridOrientation: true,
                collectionViewFlowLayout: collectionViewFlowLayout,
                edgeInset: edgeInset)
        }
        return sizeOfCell
    }
    
}


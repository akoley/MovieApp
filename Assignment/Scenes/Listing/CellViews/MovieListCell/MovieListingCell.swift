//
//  MovieListingCell.swift
//  Assignment
//
//  Created by Amrita Koley on 9/17/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import Kingfisher
import UIKit

class MovieListingCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        initMovieListingCell()
    }
    @IBOutlet weak var contentWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var releaseDateLabel: UILabel!
    
    private func initMovieListingCell() {
        titleLabel.text = nil
        releaseDateLabel.text = nil
        //contentWidthConstraint.constant = 172.5
    }
    
    func configureCell(viewModel: MovieListingCellViewModelProtocol) {
        titleLabel.text = viewModel.name
        releaseDateLabel.text = viewModel.subName
        imageView.kf.setImage(with: viewModel.imageUrl)
    }
    
    public static func getSizeOfCell(
        width: CGFloat,
        isGridOrientation: Bool,
        collectionViewFlowLayout: UICollectionViewFlowLayout!,
        edgeInset: CGFloat
        ) -> CGSize {
        var cellHeight: CGFloat = 0.0
        var cellWidth = width -
            edgeInset * 2
        
        if isGridOrientation {
            cellWidth *= 0.5
            cellWidth -= collectionViewFlowLayout != nil ? collectionViewFlowLayout.minimumInteritemSpacing * 0.5 : 0
        }
        
        let imageHeight = cellWidth * 1.5
        cellHeight += imageHeight
        
        if isGridOrientation {
            cellHeight += UIFont.MrEavesXlModOTBoldFont(fontSize: 16.0).lineHeight // Product Name
        } else {
            cellHeight += UIFont.MrEavesXlModOTBoldFont(fontSize: 18.0).lineHeight // Product Name
        }
        
        cellHeight += UIFont.MrEavesXlModOTRegularFont(fontSize: 16).lineHeight // time
        
        if isGridOrientation {
            cellHeight += 12
        } else {
            cellHeight += 12
        }
        cellHeight += 24.0
        return CGSize(width: cellWidth, height: cellHeight)
    }
}


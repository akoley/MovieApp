//
//  RUIActivityIndicatorView.swift
//  Assignment
//
//  Created by Amrita Koley on 9/22/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import UIKit

class RUIActivityIndicatorView: UIActivityIndicatorView {
    
    override init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
        initRUIActivityIndicatorView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initRUIActivityIndicatorView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initRUIActivityIndicatorView()
    }
    
    private func initRUIActivityIndicatorView() {
        self.color = UIColor.gray
        self.hidesWhenStopped = true
    }
}

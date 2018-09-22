//
//  UIViewController+Name.swift
//  Assignment
//
//  Created by Amrita Koley on 9/16/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import UIKit

extension UIViewController {
    static var className: String {
        return String(describing: self)
    }
}


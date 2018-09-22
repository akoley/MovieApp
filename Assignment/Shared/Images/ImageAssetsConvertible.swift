//
//  ImageAssetsConvertible.swift
//  Assignment
//
//  Created by Amrita Koley on 9/17/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import UIKit

protocol ImageAssetsConvertible {}

extension ImageAssetsConvertible where Self: RawRepresentable, Self.RawValue == String {
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
}

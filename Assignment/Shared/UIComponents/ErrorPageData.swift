//
//  ErrorPageData.swift
//  Assignment
//
//  Created by Amrita Koley on 9/23/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import Foundation
import UIKit

struct ErrorPageData {
    var errorMessage = Constants.ErrorString.SomethingWentWrong
    var errorImage: UIImage? = Constants.ImageAssets.noNetwork.image
    var shouldShowRetryButton = false
    var shouldShowMessage = false
}

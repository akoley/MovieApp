//
//  UIFont+App.swift
//  Assignment
//
//  Created by Amrita Koley on 9/18/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import UIKit

public extension UIFont {
    public class func MrEavesXlModOTLightFont(fontSize: CGFloat) -> UIFont {
        return UIFont.fontWithName(
            fontName: Constants.FontNameConstants.MrEavesXLModotLightFontName,
            fontSize: fontSize)
    }
    
    public class func MrEavesXlModOTRegularFont(fontSize: CGFloat) -> UIFont {
        return UIFont.fontWithName(
            fontName: Constants.FontNameConstants.MrEavesXLModotRegularFontName,
            fontSize: fontSize)
    }
    
    public class func MrEavesXlModOTBoldFont(fontSize: CGFloat) -> UIFont {
        return UIFont.fontWithName(
            fontName: Constants.FontNameConstants.MrEavesXLModotBoldFontName,
            fontSize: fontSize)
    }
    
    public class func fontWithName(fontName: String, fontSize: CGFloat) -> UIFont {
        return UIFont(name: fontName, size: fontSize)!
    }
}


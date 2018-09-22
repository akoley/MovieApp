//
//  HelperFunctions.swift
//  Assignment
//
//  Created by Amrita Koley on 9/22/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import UIKit

public struct MarginLayoutLocation: OptionSet {
    public let rawValue : Int
    public init(rawValue:Int) { self.rawValue = rawValue}
    
    static let Left                     = MarginLayoutLocation(rawValue: 0)
    static let Right                    = MarginLayoutLocation(rawValue: 1 << 0)
    static let Top                      = MarginLayoutLocation(rawValue: 1 << 1)
    static let Bottom                   = MarginLayoutLocation(rawValue: 1 << 2)
    
    public static let All                      = [ MarginLayoutLocation.Left,
                                                   MarginLayoutLocation.Right,
                                                   MarginLayoutLocation.Top,
                                                   MarginLayoutLocation.Bottom]
}

public func sizeOfWindowWrtEye() -> CGSize {
    return (UIApplication.shared.delegate?.window??.bounds.size)!
}

/**
 * Call this function after adding childview to superview's hierarchy. It will throw expection or else.
 */
public func installMatchSuperviewMarginLayoutConstraints(_ superview : UIView,
                                                         childView : UIView ,
                                                         locations : [MarginLayoutLocation] = MarginLayoutLocation.All){
    
    childView.translatesAutoresizingMaskIntoConstraints = false
    
    if locations.contains(.Left) {
        //Make child's width same as superview's width
        superview.addConstraint(NSLayoutConstraint(
            item: childView,
            attribute: NSLayoutConstraint.Attribute.leading,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: superview,
            attribute: NSLayoutConstraint.Attribute.leadingMargin,
            multiplier: 1.0,
            constant: 0.0))
    }
    
    if locations.contains(.Right) {
        superview.addConstraint(NSLayoutConstraint(
            item: childView,
            attribute: NSLayoutConstraint.Attribute.trailing,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: superview,
            attribute: NSLayoutConstraint.Attribute.trailingMargin,
            multiplier: 1.0,
            constant: 0.0))
    }
    
    if locations.contains(.Top) {
        superview.addConstraint(NSLayoutConstraint(
            item: childView,
            attribute: NSLayoutConstraint.Attribute.top,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: superview,
            attribute: NSLayoutConstraint.Attribute.topMargin,
            multiplier: 1.0,
            constant: 0.0))
    }
    
    if locations.contains(.Bottom) {
        superview.addConstraint(NSLayoutConstraint(
            item: childView,
            attribute: NSLayoutConstraint.Attribute.bottom,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: superview,
            attribute: NSLayoutConstraint.Attribute.bottomMargin,
            multiplier: 1.0,
            constant: 0.0))
    }
}

public func installCenterXInParentConstraints(_ superview : UIView,
                                              childView : UIView) -> NSLayoutConstraint{
    
    childView.translatesAutoresizingMaskIntoConstraints = false
    
    //Make child's width same as superview's width
    let layoutConstraint = NSLayoutConstraint(
        item: childView,
        attribute: NSLayoutConstraint.Attribute.centerX,
        relatedBy: NSLayoutConstraint.Relation.equal,
        toItem: superview,
        attribute: NSLayoutConstraint.Attribute.centerX,
        multiplier: 1.0,
        constant: 0.0)
    superview.addConstraint(layoutConstraint)
    return layoutConstraint
}

public func installCenterYInParentConstraints(_ superview : UIView,
                                              childView : UIView) -> NSLayoutConstraint {
    
    childView.translatesAutoresizingMaskIntoConstraints = false
    let layoutConstraint = NSLayoutConstraint(
        item: childView,
        attribute: NSLayoutConstraint.Attribute.centerY,
        relatedBy: NSLayoutConstraint.Relation.equal,
        toItem: superview,
        attribute: NSLayoutConstraint.Attribute.centerY,
        multiplier: 1.0,
        constant: 0.0)
    superview.addConstraint(layoutConstraint)
    return layoutConstraint
}

public func installCenterInParentConstraints(_ superview : UIView, childView : UIView){
    _ = installCenterXInParentConstraints(superview, childView: childView)
    _ = installCenterYInParentConstraints(superview, childView: childView)
}

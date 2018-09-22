//
//  DateTransform.swift
//  Assignment
//
//  Created by Amrita Koley on 9/18/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import UIKit
import ObjectMapper

open class StringToDateTransform: TransformType  {
    public typealias Object = String
    public typealias JSON = String
    
    public init() {}
    
    open func transformFromJSON(_ value: Any?) -> String? {
        if let rawDate = value as? String {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            
            let date = dateFormat.date(from: rawDate)
            dateFormat.dateStyle = DateFormatter.Style.medium
            if(date != nil) {
                return dateFormat.string(from: date!)
            }
            
            return nil
        }
        return nil
    }
    
    open func transformToJSON(_ value: String?) -> String? {
        return value
    }
}


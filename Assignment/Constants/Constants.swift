//
//  Constants.swift
//  Assignment
//
//  Created by Amrita Koley on 9/17/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import Foundation

struct Constants {
    struct Api {
        static let apiBaseURL: String = {
            let path = Bundle.main.path(forResource: "Info", ofType: "plist")!
            if let dict = NSDictionary(contentsOfFile: path) {
                // swiftlint:disable:next force_cast
                return dict["ApiBaseURL"] as! String
            }
            return ""
        }()
        
        static let imageBaseURL: String = {
            let path = Bundle.main.path(forResource: "Info", ofType: "plist")!
            if let dict = NSDictionary(contentsOfFile: path) {
                // swiftlint:disable:next force_cast
                return dict["ImageBaseURL"] as! String
            }
            return ""
        }()
        
    }
    
    struct ErrorString {
        static let SomethingWentWrong = "Bummer! Something went wrong. Please try again."
        static let NoInternetConnection = "No internet connection!"
    }
    
    struct FontNameConstants {
        static let MrEavesXLModotLightFontName = "MrEavesXLModOT-Light"
        static let MrEavesXLModotRegularFontName = "MrEavesXLModOT-Reg"
        static let MrEavesXLModotBoldFontName = "MrEavesXLModOT-Bold"
    }
    
    struct StringConstants {
        static let Search = "Search"
        static let Retry = "Retry"
        static let NoResults = "No results found for "
    }

    struct CoreData {
        
        
        static let CoreDataFileName = "Assignment.sqlite"
        static let CoreDataModel = "Assignment"
        
        struct Models {
            static let ModelManagerEntity = "ModelManager"
            static let RecentSearchEntity = "RecentSearch"
            static let RecentSearchesEntity = "recentSearches"
        }

    }
    
    struct MovieListing {}
    
    enum ImageAssets: String, ImageAssetsConvertible {
        case noNetwork
    }
    
    enum TabBarIcons: String, ImageAssetsConvertible {
        case home
        case notification
        case account
    }
}

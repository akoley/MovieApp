//
//  SearchRouter.swift
//  Assignment
//
//  Created by Amrita Koley on 9/16/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import Alamofire

enum SearchRouter: APIRouter {
    case searchSuggesions([String: Any])
    
    case searchTerm([String: Any], String)
    
    var route: Route {
        switch self {
        case let .searchSuggesions(parameters):
            return Route(method: .get, path: "/api/search/suggestions", parameters: parameters)
            
        case let .searchTerm(parameters, path):
            return Route(method: .get, path: path, parameters: parameters)
        }
    }
}

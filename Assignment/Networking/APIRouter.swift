//
//  APIRouter.swift
//  Assignment
//
//  Created by Amrita Koley on 9/16/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import Alamofire

struct Route {
    let method: HTTPMethod
    let path: String
    let parameters: Parameters?
}

protocol APIRouter: URLRequestConvertible {
    var route: Route { get }
}

extension APIRouter {
    // MARK: - URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.Api.apiBaseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(route.path))
        
        // HTTP Method
        urlRequest.httpMethod = route.method.rawValue
        
        // Common Headers
        //urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        //urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            if route.method == .get {
                urlRequest = try URLEncoding.default.encode(urlRequest, with: route.parameters)
            } else {
                urlRequest = try JSONEncoding.default.encode(urlRequest, with: route.parameters)
            }
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }
        
        return urlRequest
    }
}


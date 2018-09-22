//
//  APIClient.swift
//  Assignment
//
//  Created by Amrita Koley on 9/16/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class APIClient {
    
    private static func _sendRequestWithHTTPResponse<T: Mappable>(_ request : DataRequest, relativeUrlPath : String! = nil, type : T.Type, shouldTrackRequest : Bool = false, completionHandler: @escaping (DataResponse<T>) -> Void) {
        let requestStartTime = Date()
        
        request.responseObject { (response: DataResponse<T>) -> Void in
            if(shouldTrackRequest) {
                _onRequestCompletion(requestStartTime, api: relativeUrlPath, response : response)
            }
            completionHandler(response)
        }
    }
    
    private class func _onRequestCompletion<T: Mappable>(_ requestStartTime : Date, api : String, response : DataResponse<T>) {
       
        //Analytics code should go here
    }
    
    private class func _sendRequest<T: Mappable>(_ request : DataRequest,
                                                     relativeUrlPath : String! = nil,
                                                     type : T.Type, shouldTrackRequest : Bool = false,
                                                     completionHandler: @escaping (Result<T>) -> Void) {
        _sendRequestWithHTTPResponse(request, relativeUrlPath: relativeUrlPath, type: type, shouldTrackRequest: shouldTrackRequest) { (response) -> Void in
            
            var error = response.result.error
            if response.result.error != nil {
                let code = (error as NSError?)?.code ?? 0
                error = NSError(domain: Bundle.main.bundleIdentifier!, code: code, userInfo: [NSLocalizedDescriptionKey : Constants.ErrorString.SomethingWentWrong])
            }
            completionHandler(response.result)
            OperationQueue.current?.cancelAllOperations()
            return
        }
    }
    
    class func getSearchResults(searchTerm: String?,
                                     page: Int,
                                     completionHandler: @escaping (Result<MovieListingResponse>) -> Void) {
        var parameter: [String: Any] = [:]
        let url = "/3/search/movie"
        parameter["api_key"] = "2696829a81b1b5827d515ff121700838"
        parameter["query"] = searchTerm
        parameter["page"] = page
        let searchRoute = SearchRouter.searchTerm(parameter, url)
        let request = Alamofire.request(searchRoute).validate()
        _sendRequest(request,
                     type: MovieListingResponse.self,
                     completionHandler: completionHandler)
    }
}


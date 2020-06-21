//
//  ConfigurationsAPi.swift
//  Nasa
//
//  Created by Jhon Ospino Bernal on 20/06/20.
//  Copyright © 2020 Jhon Ospino Bernal. All rights reserved.
//

import Foundation

public struct ConfigurationsAPi {
    
    static let urlBase = "https://images-api.nasa.gov"
    static let endpoint = "/search"
    static let parameters :[String: String] = ["q":"apollo 11"]
    
    
    enum Method: String {
        case get, post, put, delete
    }
    
    enum RequestError: Error {
        case invalidURL, noHTTPResponse, http(status: Int)
        
        var localizedDescription: String {
            switch self {
            case .invalidURL:
                return "Invalid URL."
            case .noHTTPResponse:
                return "Not a HTTP response."
            case .http(let status):
                return "HTTP error: \(status)."
            }
        }
    }
    
}

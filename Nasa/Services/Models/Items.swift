//
//  Items.swift
//  Nasa
//
//  Created by Jhon Ospino Bernal on 16/06/20.
//  Copyright © 2020 Jhon Ospino Bernal. All rights reserved.
//

import UIKit

public struct Items: Codable {
    
    public let href : String
    public let data : [DataItems]
    public let links : [Links]?
    
    private enum CodingKeys : String, CodingKey{
        
        case href
        case data
        case links
    }
    
    
}

public struct DataItems : Codable {
    
    public let center : String
    public let dateCreated : String
    public let nasaId : String
    public let description : String
    public let location : String?
    public let photographer : String?
    public let keywords : [String]
    public let title : String
    public let mediaType: String
    
    
    private enum CodingKeys : String, CodingKey {
        
        case center
        case dateCreated = "date_created"
        case nasaId = "nasa_id"
        case description
        case location
        case photographer
        case keywords
        case title
        case mediaType = "media_type"
    }
    
}

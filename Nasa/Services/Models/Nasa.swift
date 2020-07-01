//
//  Nasa.swift
//  Nasa
//
//  Created by Jhon Ospino Bernal on 15/06/20.
//  Copyright © 2020 Jhon Ospino Bernal. All rights reserved.
//

import UIKit

public struct Nasa: Codable {
    public let collection : Collection
}

public struct Collection : Codable{
    
    public let metadata : MetaData
    public let href : String
    public let links : [Links]?
    public let items : [Items]
    public let version: String
    
    private enum CodingKeys : String, CodingKey{
        case metadata
        case href
        case links
        case items
        case version
        
    }
    

}

public struct MetaData : Codable{
    public let totalHits : Int
    
    private enum CodingKeys : String, CodingKey{
        case totalHits = "total_hits"
    }
}

public struct Links : Codable{
    public let rel : String?
    public let prompt : String?
    public let href : String
    public let render : String?
}







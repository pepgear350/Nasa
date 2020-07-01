//
//  LinksDB+CoreDataProperties.swift
//  Nasa
//
//  Created by Jhon Ospino Bernal on 27/06/20.
//  Copyright © 2020 Jhon Ospino Bernal. All rights reserved.
//
//

import Foundation
import CoreData


extension LinksDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LinksDB> {
        return NSFetchRequest<LinksDB>(entityName: "LinksDB")
    }

    @NSManaged public var href: String?
    @NSManaged public var rel: String?
    @NSManaged public var render: String?
    @NSManaged public var data_relation: DataDB?

}

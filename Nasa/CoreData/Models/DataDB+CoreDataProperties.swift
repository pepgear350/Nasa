//
//  DataDB+CoreDataProperties.swift
//  Nasa
//
//  Created by Jhon Ospino Bernal on 27/06/20.
//  Copyright © 2020 Jhon Ospino Bernal. All rights reserved.
//
//

import Foundation
import CoreData


extension DataDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataDB> {
        return NSFetchRequest<DataDB>(entityName: "DataDB")
    }

    @NSManaged public var center: String?
    @NSManaged public var date_created: String?
    @NSManaged public var description_data: String?
    @NSManaged public var location: String?
    @NSManaged public var media_type: String?
    @NSManaged public var nasa_id: String?
    @NSManaged public var photographer: String?
    @NSManaged public var title: String?
    @NSManaged public var keywords: Array<String>?
    @NSManaged public var link_relation: Set<LinksDB>?

}

// MARK: Generated accessors for link_relation
extension DataDB {

    @objc(addLink_relationObject:)
    @NSManaged public func addToLink_relation(_ value: LinksDB)

    @objc(removeLink_relationObject:)
    @NSManaged public func removeFromLink_relation(_ value: LinksDB)

    @objc(addLink_relation:)
    @NSManaged public func addToLink_relation(_ values: NSSet)

    @objc(removeLink_relation:)
    @NSManaged public func removeFromLink_relation(_ values: NSSet)

}

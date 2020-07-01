//
//  DataController.swift
//  Nasa
//
//  Created by Jhon Ospino Bernal on 27/06/20.
//  Copyright © 2020 Jhon Ospino Bernal. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    let persistentContainer = NSPersistentContainer(name: "Nasa")
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func initalizeDB(completion: @escaping () -> Void) {
        self.setStore(type: NSInMemoryStoreType)
        self.persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print("could not load store \(error.localizedDescription)")
                return
            }
            print("store loaded")
            completion()
        }
    }
    
    func setStore(type: String) {
        let description = NSPersistentStoreDescription()
        description.type = type // types: NSInMemoryStoreType, NSSQLiteStoreType, NSBinaryStoreType
        
        if type == NSSQLiteStoreType || type == NSBinaryStoreType {
            description.url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                .first?.appendingPathComponent("database")
        }
        
        self.persistentContainer.persistentStoreDescriptions = [description]
    }
    
    func fetchData() throws -> [DataDB] {
        let data = try self.context.fetch(DataDB.fetchRequest() as NSFetchRequest<DataDB>)
        return data
    }
    //
    //    func fetchUsers(withName name: String) throws -> [User] {
    //        let request = NSFetchRequest<User>(entityName: "User")
    //        request.predicate = NSPredicate(format: "firstName == %@", name)
    //
    //        let users = try self.context.fetch(request)
    //        return users
    //    }
    //
    func insert(items: [Items]) throws {
        
        for item in items{
            let dataDB = DataDB(context: self.context)
            dataDB.center = item.data[0].center
            dataDB.date_created = item.data[0].dateCreated
            dataDB.description_data = item.data[0].description
            dataDB.location = item.data[0].location
            dataDB.media_type = item.data[0].mediaType
            dataDB.nasa_id = item.data[0].nasaId
            dataDB.photographer = item.data[0].photographer
            dataDB.title = item.data[0].title
            dataDB.keywords = item.data[0].keywords
            
            item.links?.forEach{ link in
                
                guard link.rel == "preview" else {
                    return
                }
                
                let linksDB = LinksDB(context: self.context)
                linksDB.href = link.href
                linksDB.rel = link.rel
                linksDB.render = link.render
                dataDB.addToLink_relation(linksDB)
            }
            
            self.context.insert(dataDB)
        }
        try self.context.save()
    }
    //
    //    func update(user: User) throws {
    //        user.firstName = "Jack"
    //        try self.context.save()
    //    }
    //
        func delete(dataDB: DataDB) throws {
            self.context.delete(dataDB)
            try self.context.save()
        }
    //
    //    func deleteUsers(withName name: String) throws {
    //        let fetchRequest = User.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
    //        fetchRequest.predicate = NSPredicate(format: "firstName == %@", name)
    //
    //        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    //        try self.context.execute(deleteRequest)
    //        try self.context.save()
    //    }
}

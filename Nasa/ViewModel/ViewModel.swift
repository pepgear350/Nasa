//
//  ViewModel.swift
//  Nasa
//
//  Created by Jhon Ospino Bernal on 29/06/20.
//  Copyright © 2020 Jhon Ospino Bernal. All rights reserved.
//

import UIKit
import CoreData

class ViewModel {
    
    fileprivate let dataController = DataController()
    fileprivate let dataSource = NasaDataSource()
    
    
    
    func initalizateDB(completion: @escaping (NSFetchedResultsController<DataDB>) -> Void) {
        dataController.initalizeDB {
            let request = DataDB.fetchRequest() as NSFetchRequest<DataDB>
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            let fetchController = NSFetchedResultsController(fetchRequest: request,
                                                             managedObjectContext: self.dataController.context,
                                                             sectionNameKeyPath: nil, cacheName: nil)
            completion(fetchController)
        }
    }
    
    
    func startFetch() {
        self.dataSource.startLoad { items,error in
            
            if error != nil {
                return
            }
            
            if let items = items {
                try? self.dataController.insert(items: items)
            }
            
        }
    }
    
    func deleteDataDB(dataDB : DataDB) {
        try? dataController.delete(dataDB: dataDB)
    }
}


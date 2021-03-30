//
//  PersistenceManager.swift
//  Invysta Aware
//
//  Created by Cyril Garcia on 3/29/21.
//

import CoreData
import Foundation
import InvystaCore

final class PersistenceManager {
    
    static let shared = PersistenceManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
   
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    
    func deleteAll() {
        let savedItems = fetch(Activity.self)
        
        savedItems.forEach { (item) in
            let context = persistentContainer.viewContext
            context.delete(item)
            
            try? context.save()
        }
    }
    
    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
   
    func fetch<T: NSManagedObject>(_ objectType: T.Type) -> [T] {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            
            let fetchedObjects = try context.fetch(fetchRequest) as? [T]
            return fetchedObjects ?? [T]()
            
        } catch {
            InvystaService.log(.error,"\(type(of: self))", error.localizedDescription)
            return [T]()
        }
        
    }
}

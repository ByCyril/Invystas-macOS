//
//  ActivityManager.swift
//  Invysta Aware
//
//  Created by Cyril Garcia on 3/29/21.
//


import Foundation
import CoreData

final class ActivityManager {
    let persistenceManager: PersistenceManager
    
    init(_ persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
    }
    
    func saveResults(activity: Activity) {
        persistenceManager.save()
    }
    
}

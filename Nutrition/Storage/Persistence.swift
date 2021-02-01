//
//  Persistence.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-27.
//

import CoreData

final class PersistenceController: ObservableObject {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false, loaded: (() -> Void)? = nil) {
        container = NSPersistentContainer(name: "Nutrition")
        if inMemory || UserDefaults.standard.bool(forKey: "uitesting") {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            loaded?()
        }
    }
    
    func saveChanges(success: (() -> Void)? = nil, failure: ((NSError) -> Void)? = nil)   {
        guard container.viewContext.hasChanges else { return }
        do {
            try container.viewContext.save()
            
            if let onSuccess = success {
                onSuccess()
            }
        } catch let error as NSError {
            assertionFailure("Error: \(error), \(error.userInfo)")
            
            if let onFailure = failure {
                onFailure(error)
            }
        }
    }
}

//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import os.log
import Foundation
import CoreData

class ClickCountDBManager {
    static let shared = ClickCountDBManager()
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: ClickCountDBManager.self)
    )

    struct CoreDataElement: Identifiable {
        let id: String
        let count: Int
    }

    private let entityName = "ClickCountEntity"
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ClickCount")
        container.loadPersistentStores { (_, error) in
            if let error {
                self.logger.critical("persistentContainer: \(error as NSError))")
            }
        }
        return container
    }()
    private lazy var managedContext = persistentContainer.viewContext

    private func create(id: String) {
        managedContext.performAndWait {
            let entity = NSEntityDescription.entity(
                forEntityName: entityName,
                in: managedContext
            )!
            let newEntity = NSManagedObject(entity: entity, insertInto: managedContext)
            newEntity.setValue(id, forKeyPath: "id")
            newEntity.setValue(1, forKeyPath: "count")
            do {
                try managedContext.save()
            } catch let error as NSError {
                logger.critical("create(id: \(id)): Could not save. \(error), \(error.userInfo)")
            }
        }
    }

    func increaseByOne(id: String) {
        managedContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            do {
                let objects = try managedContext.fetch(fetchRequest)
                if let newEntity = objects.first {
                    guard let previousCount = newEntity.value(forKey: "count") as? Int else {
                        logger.critical("increaseByOne(id: \(id): Error decoding \(self.entityName)")
                        return
                    }
                    let newCount = previousCount + 1
                    newEntity.setValue(newCount, forKey: "count")
                    try managedContext.save()
                } else {
                    create(id: id)
                }
            } catch let error as NSError {
                logger.critical("increaseByOne(id: \(id)): Could not fetch/save. \(error), \(error.userInfo)")
            }
        }
    }

    func read(id: String) -> Int? {
        managedContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            do {
                let objects = try managedContext.fetch(fetchRequest)
                guard let entity = objects.first else {
                    return nil
                }
                guard let count = entity.value(forKey: "count") as? Int else {
                    logger.critical("read(id: \(id)): Error decoding \(self.entityName)")
                    return nil
                }
                return count
            } catch let error as NSError {
                logger.critical("read(id: \(id)): Could not fetch. \(error), \(error.userInfo)")
                return nil
            }
        }
    }

    func read() -> [CoreDataElement] {
        managedContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
            do {
                let result = try managedContext.fetch(fetchRequest)
                let mappedResult = result.compactMap {
                    CoreDataElement(
                        id: $0.value(forKey: "id") as? String ?? "nil",
                        count: $0.value(forKey: "count") as? Int ?? -1
                    )
                }
                return mappedResult
            } catch let error as NSError {
                logger.critical("read(): Could not fetch. \(error), \(error.userInfo)")
            }
            return []
        }
    }

    func reset() {
        managedContext.performAndWait {
            do {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
                for object in try managedContext.fetch(fetchRequest) {
                    managedContext.delete(object)
                }
                guard let url = persistentContainer.persistentStoreDescriptions.first?.url else { return }
                let persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
                try persistentStoreCoordinator.destroyPersistentStore(
                    at: url,
                    ofType: NSSQLiteStoreType,
                    options: nil
                )
                try persistentStoreCoordinator.addPersistentStore(
                    ofType: NSSQLiteStoreType,
                    configurationName: nil,
                    at: url,
                    options: nil
                )
            } catch {
                logger.critical("reset(): Could not reset. \(error)")
            }
        }
    }
}

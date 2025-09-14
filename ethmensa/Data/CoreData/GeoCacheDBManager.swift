//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import CoreData
import CoreLocation
import Foundation
import os.log

class GeoCacheDBManager {
    static let shared = GeoCacheDBManager()
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: GeoCacheDBManager.self)
    )

    struct CoreDataElement: Identifiable {
        var id: String {
            address
        }
        let address: String
        let long: Double
        let lat: Double

        var debugString: String {
            "\(id) - \(address) - \(lat), \(long)"
        }
    }

    private let entityName = "GeoCacheEntity"
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GeoCache")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error {
                self.logger.critical("persistentContainer: \(error as NSError))")
            }
        })
        return container
    }()
    private lazy var managedContext = persistentContainer.viewContext

    private func create(geoCache: CoreDataElement) {
        managedContext.performAndWait {
            let entity = NSEntityDescription.entity(
                forEntityName: entityName,
                in: managedContext
            )!
            let newEntity = NSManagedObject(entity: entity, insertInto: managedContext)
            newEntity.setValue(geoCache.address, forKeyPath: "address")
            newEntity.setValue(geoCache.long, forKeyPath: "long")
            newEntity.setValue(geoCache.lat, forKeyPath: "lat")
            do {
                try managedContext.save()
            } catch let error as NSError {
                logger.critical("\(#function): Could not save. \(error)")
            }
        }
    }

    func update(geoCache: CoreDataElement) {
        managedContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
            fetchRequest.predicate = NSPredicate(format: "address == %@", geoCache.address)
            do {
                let objects = try managedContext.fetch(fetchRequest)
                if let newEntity = objects.first {
                    newEntity.setValue(geoCache.long, forKey: "long")
                    newEntity.setValue(geoCache.lat, forKey: "lat")
                    try managedContext.save()
                } else {
                    create(
                        geoCache: .init(
                            address: geoCache.address,
                            long: geoCache.long,
                            lat: geoCache.lat
                        )
                    )
                }
            } catch let error as NSError {
                logger.critical("\(#function): Could not fetch/save. \(error)")
            }
        }
    }

    func read(address: String) -> CLLocation? {
        managedContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
            fetchRequest.predicate = NSPredicate(format: "address == %@", address)
            do {
                let objects = try managedContext.fetch(fetchRequest)
                guard let entity = objects.first else {
                    return nil
                }
                guard let long = entity.value(forKey: "long") as? Double,
                      let lat = entity.value(forKey: "lat") as? Double else {
                    logger.critical("\(#function): Error decoding \(self.entityName)")
                    return nil
                }
                return CLLocation(latitude: lat, longitude: long)
            } catch let error as NSError {
                logger.critical("\(#function): Could not fetch. \(error), \(error.userInfo)")
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
                        address: $0.value(forKey: "address") as? String ?? "nil",
                        long: $0.value(forKey: "long") as? Double ?? -1,
                        lat: $0.value(forKey: "lat") as? Double ?? -1
                    )
                }
                return mappedResult
            } catch let error as NSError {
                logger.critical("\(#function): Could not fetch. \(error), \(error.userInfo)")
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
                logger.critical("\(#function): Could not reset. \(error)")
            }
        }
    }
}

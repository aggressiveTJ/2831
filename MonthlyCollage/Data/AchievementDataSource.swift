//
//  AchievementDataSource.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/23.
//  Copyright © 2020 TJ. All rights reserved.
//

import Combine
import CoreData

final class AchievementDataSource<T: NSManagedObject>: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    // MARK: Trivial publisher for our changes.
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    //MARK: - Initializer
    
    init(sortKey: String? = nil,
         sectionNameKeyPath: String? = nil,
         predicateKey: String? = nil,
         predicateObject: NSManagedObject? = nil,
         sortAscending: Bool? = nil,
         predicate: NSPredicate? = nil,
         entity: NSEntityDescription? = nil) {
        self.sortKey = sortKey ?? "date"
        self.sectionNameKeyPath = sectionNameKeyPath
        self.predicateKey = predicateKey
        self.predicateObject = predicateObject
        self.sortAscending = sortAscending ?? true
        self.predicate = predicate
        self.entity = entity
        
        fetchedResultsController = NSFetchedResultsController<T>()
        
        super.init()
        
        contextDidSaveNotifications.addObserver(managedObjectContextDidSave)
    }
    
    // MARK: - Private Properties
    private var sortKey: String = "date"
    private var sectionNameKeyPath: String? = nil
    private var predicateKey: String? = nil
    private var predicateObject: NSManagedObject? = nil
    private var sortAscending: Bool = true
    private var predicate: NSPredicate? = nil
    private var entity: NSEntityDescription? = nil
    
    private var fetchedResultsController: NSFetchedResultsController<T>
    
    private let contextDidSaveNotifications = ManagedObjectContextDidSaveNotifications()
    
    // MARK: - Fetch Modifiers
    public func sortKey(_ sortKey: String?) -> AchievementDataSource {
        self.sortKey = sortKey ?? "date"
        return self
    }
    
    public func sectionNameKeyPath(_ sectionNameKeyPath: String?) -> AchievementDataSource {
        self.sectionNameKeyPath = sectionNameKeyPath
        return self
    }
    
    public func predicateKey(_ predicateKey: String?) -> AchievementDataSource {
        self.predicateKey = predicateKey
        return self
    }
    
    public func predicateObject(_ predicateObject: NSManagedObject?) -> AchievementDataSource {
        self.predicateObject = predicateObject
        return self
    }
    
    public func sortAscending(_ sortAscending: Bool?) -> AchievementDataSource {
        self.sortAscending = sortAscending ?? true
        return self
    }
    
    public func predicate(_ predicate: NSPredicate?) -> AchievementDataSource {
        self.predicate = predicate
        return self
    }
    
    public func entity(_ entity: NSEntityDescription?) -> AchievementDataSource {
        self.entity = entity
        return self
    }
    
    // MARK: - Private Methods
    
    // Constructs a Fetch Request based on current query properties
    private func configureFetchRequest() -> NSFetchRequest<T> {
        
        let fetchRequest = T.fetchRequest() as! NSFetchRequest<T>
        fetchRequest.fetchBatchSize = 0
        
        if let entity = entity {
            fetchRequest.entity = entity
        }
        
        let sortDescriptor = NSSortDescriptor(key: sortKey, ascending: sortAscending)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        } else {
            if let predicateKey = predicateKey {
                if let predicateObject = predicateObject {
                    let predicateString = String(format: "%@%@", predicateKey, " == %@")
                    fetchRequest.predicate = NSPredicate(format: predicateString, predicateObject)
                } else {
                    let predicateString = String(format: "%@%@", predicateKey, " = $OBJ")
                    let predicate = NSPredicate(format: predicateString)
                    fetchRequest.predicate = predicate.withSubstitutionVariables(["OBJ": NSNull()])
                }
            } else {
                fetchRequest.predicate = nil
            }
        }
        
        return fetchRequest
    }
    
    // Constructs a Fetch Request and a FRC
    private func configureFetchedResultsController() -> NSFetchedResultsController<T> {
        let fetchRequest = configureFetchRequest()
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: DataManager.shared.context,
                                                                  sectionNameKeyPath: sectionNameKeyPath,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }
    
    // Constructs a FRC and performs the Fetch
    private func performFetch() {
        do {
            fetchedResultsController = configureFetchedResultsController()
            try fetchedResultsController.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    // MARK: Public Properties
    
    // Accessor Property to access FRC fetched objects without Fetch
    public var fetchedObjects: [T] {
        fetchedResultsController.fetchedObjects ?? []
    }
    
    // Property to perform Fetch and supply results as an array to ForEach
    public var objects:[T] {
        performFetch()
        return fetchedObjects
    }
    
    // MARK: Public Methods that don't use FRC
    
    // Fetches all NSManagedObjects directly into an array
    public func fetch() -> [T] {
        let fetchRequest = configureFetchRequest()
        do {
            let objects = try DataManager.shared.context.fetch(fetchRequest)
            return objects
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
            return [T]()
        }
    }
    
    // Count all NSManagedObjects for current Fetch Request
    public var count: Int {
        let fetchRequest = configureFetchRequest()
        do {
            let count = try DataManager.shared.context.count(for: fetchRequest)
            return count
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
            return 0
        }
    }
    
    // MARK: Support for List Editing
    
    // 'delete' method for single-section Lists
    public func delete(from source: IndexSet) {
        DataManager.executeBlockAndCommit {
            for index in source {
                DataManager.shared.context.delete(self.fetchedObjects[index])
            }
        }
    }
    
    // MARK: Support for nested Lists with sectionNameKeyPath
    
    // Used to supply Data to a ForEach List's outer loop
    public var sections: [NSFetchedResultsSectionInfo] {
        performFetch()
        return fetchedResultsController.sections!
    }
    
    // Used to supply Data to a ForEach List's inner loop
    public func objects(inSection: NSFetchedResultsSectionInfo) -> [T] {
        return inSection.objects as! [T]
    }
    
    // 'delete' method that adjusts for multi-section Lists
    public func delete(from source: IndexSet, inSection: NSFetchedResultsSectionInfo) {
        DataManager.executeBlockAndCommit {
            for index in source {
                DataManager.shared.context.delete(self.objects(inSection: inSection)[index])
            }
        }
    }
    
    // MARK: CoreDataDataSource + NSFetchedResultsControllerDelegate
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        objectWillChange.send()
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        objectWillChange.send()
    }
    
    // MARK: - NSNotification
    
    private func managedObjectContextDidSave(_ aNotification: Notification) {
        if sectionNameKeyPath != nil {
            objectWillChange.send()
        }
    }
}

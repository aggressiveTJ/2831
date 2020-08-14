//
//  DataManager.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/11.
//  Copyright © 2020 TJ. All rights reserved.
//

import CoreData

final class DataManager: NSObject {
    static let shared = DataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Challenges")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    public var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    public func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Database setup
    
    public class func initialDbSetup() -> Void {
        if Challenge.count() == 0 {
            for i in 0...4 {
                _ = Challenge.createChallenge(name: "dummy \(i)")
            }
        }
    }
    
    // MARK: - Managed Object Helpers
    
    class func executeBlockAndCommit(_ block: @escaping () -> Void) {
        block()
        DataManager.shared.save()
    }
}

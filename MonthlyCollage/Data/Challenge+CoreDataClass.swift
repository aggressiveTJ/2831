//
//  Challenge+CoreDataClass.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/11.
//  Copyright © 2020 TJ. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Challenge)
public class Challenge: NSManagedObject {
    // MARK: Helpers
    class func count() -> Int {
        let fetchRequest: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        
        do {
            let count = try DataManager.shared.context.count(for: fetchRequest)
            return count
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    class func allChallenge() -> [Challenge] {
        let datasource = ChallengeDataSource<Challenge>()
        return datasource.fetch()
    }
    
    #if DEBUG
    class func preview() -> Challenge {
        let challenge = Challenge.allChallenge()
        if challenge.count > 0 {
            return challenge.first!
        } else {
            return Challenge.createChallenge(name: "Preview")
        }
    }
    #endif
}

// MARK: - CRUD
extension Challenge {
    class func createChallenge(name: String, id: UUID = UUID(), date: Date = Date()) -> Challenge {
        let challenge = Challenge(context: DataManager.shared.context)
        challenge.id = id
        challenge.name = name
        challenge.date = date
        
        DataManager.shared.save()
        
        return challenge
    }
    
    public func update(name: String) {
        self.name = name
        DataManager.shared.save()
    }
    
    public func update(date: Date) {
        self.date = date
        DataManager.shared.save()
    }
    
    public func delete() {
        DataManager.shared.context.delete(self)
    }
}

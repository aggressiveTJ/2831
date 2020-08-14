//
//  Challenge+CoreDataProperties.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/11.
//  Copyright © 2020 TJ. All rights reserved.
//
//

import Foundation
import CoreData


extension Challenge {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Challenge> {
        return NSFetchRequest<Challenge>(entityName: "Challenge")
    }
    
    @NSManaged public var date: Date
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    
}

//
//  Achievement+CoreDataProperties.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/23.
//  Copyright © 2020 TJ. All rights reserved.
//
//

import Foundation
import CoreData


extension Achievement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Achievement> {
        return NSFetchRequest<Achievement>(entityName: "Achievement")
    }

    @NSManaged public var date: Date
    @NSManaged public var id: UUID
    @NSManaged public var name: String

}

//
//  Achievement+CoreDataClass.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/23.
//  Copyright © 2020 TJ. All rights reserved.
//
//

import Foundation
import UIKit
import CoreData

@objc(Achievement)
public class Achievement: NSManagedObject, Identifiable {
    class func all() -> [Achievement] {
        let datasource = AchievementDataSource<Achievement>()
        return datasource.fetch()
    }
    
    #if DEBUG
    class func preview() -> Achievement {
        let achievements = Achievement.all()
        if achievements.count > 0 {
            return achievements.first!
        } else {
            return Achievement.create(from: Challenge.preview())
        }
    }
    #endif
    
    private var baseDirectory: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("achievement", isDirectory: true)
    }
    
    var imageURL: URL? {
        let fileManager = FileManager()
        if !fileManager.fileExists(atPath: baseDirectory.path) {
            do {
                try fileManager.createDirectory(at: baseDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        
        return baseDirectory.appendingPathComponent("\(id.uuidString).jpg")
    }
    
    var image: UIImage? {
        if let imagePath = imageURL?.path {
            return UIImage(contentsOfFile: imagePath)
        }
        
        return nil
    }
}

// MARK: - CRUD
extension Achievement {
    class func create(from challenge: Challenge) -> Achievement {
        let achievement = Achievement(context: DataManager.shared.context)
        achievement.id = challenge.id
        achievement.name = challenge.name
        achievement.date = challenge.date
        
        DataManager.shared.save()
        
        return achievement
    }
    
    public func delete() {
        DataManager.shared.context.delete(self)
    }
}

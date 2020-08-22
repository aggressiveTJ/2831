//
//  Challenge+CoreDataClass.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/11.
//  Copyright © 2020 TJ. All rights reserved.
//
//

import Foundation
import UIKit
import CoreData

@objc(Challenge)
public class Challenge: NSManagedObject, Identifiable {
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

extension Challenge {
    var baseDirectory: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(id.uuidString, isDirectory: true)
    }
    
    func image(with date: Date) -> UIImage? {
        do {
            let imageData = try Data(contentsOf: imagePath(with: date))
            return UIImage(data: imageData)
        } catch {
            return nil
        }
    }
    
    func imagePath(with date: Date) -> URL {
        let fileManager = FileManager()
        if !fileManager.fileExists(atPath: baseDirectory.path) {
            try? fileManager.createDirectory(at: baseDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        
        return baseDirectory.appendingPathComponent("\(id.uuidString)_\(date.postfix).jpg")
    }
    
    func isComplete(with date: Date) -> Bool {
        FileManager().fileExists(atPath: imagePath(with: date).path)
    }
    
    func images() -> [UIImage] {
        var images: [UIImage] = []
        let fileManager = FileManager()

        do {
            for path in try fileManager.contentsOfDirectory(atPath: baseDirectory.path).sorted() {
                if path.hasPrefix(id.uuidString),
                   let image = UIImage(contentsOfFile: baseDirectory.appendingPathComponent(path, isDirectory: false).path) {
                    images.append(image)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return images
    }
}

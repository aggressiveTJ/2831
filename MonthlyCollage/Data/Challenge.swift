//
//  Challenge.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/26.
//  Copyright © 2020 TJ. All rights reserved.
//

import Foundation
import UIKit

struct Challenge: Identifiable, Equatable, Codable {
    static var fileName = "2831_challenge.dat"
    static let preview = Challenge(title: "Preview")
    
    let id: UUID
    let title: String
    let startDate: Date
    
    init(title: String, startDate: Date = Date()) {
        self.id = UUID()
        self.title = title
        self.startDate = startDate
    }
    
    fileprivate var baseDirectory: URL? {
        DataManager.appLibraryDirectory?.appendingPathComponent(id.uuidString, isDirectory: true)
    }
    var days: [Day] {
        guard let interval = Calendar.current.dateInterval(of: .month, for: startDate) else {
            return []
        }
        
        var days: [Day] = [Day(date: interval.start, in: self)]
        Calendar.current.enumerateDates(startingAfter: interval.start, matching: DateComponents(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime, using: { (date, _, stop) in
            if let date = date {
                if date < interval.end {
                    days.append(Day(date: date, in: self))
                } else {
                    stop = true
                }
            }
        })
        
        return days
    }
    
    @discardableResult func register() -> Bool {
        guard !DataManager.shared.challenges.contains(self) else {
            return false
        }
        
        DataManager.shared.challenges.append(self)
        return true
    }
    
    @discardableResult func modify() -> Bool {
        guard let index = DataManager.shared.challenges.firstIndex(of: self) else {
            return false
        }
        
        DataManager.shared.challenges[index] = self
        return true
    }
    
    func complete() -> Achievement? {
        let achievement = Achievement(challenge: self)
        guard let path = achievement.imagePath,
              let image = days.collage(title: achievement.title),
              image.save(in: URL(fileURLWithPath: path), square: false) else {
            return nil
        }
        
//        defer {
//            remove()
//        }
        
        if let index = DataManager.shared.achievements.firstIndex(of: achievement) {
            DataManager.shared.achievements[index] = achievement
        } else {
            DataManager.shared.achievements.append(achievement)
        }
        
        return achievement
    }
    
    @discardableResult func remove() -> Bool {
        guard let index = DataManager.shared.challenges.firstIndex(of: self) else {
            return false
        }
        
        defer {
            DataManager.shared.challenges.remove(at: index)
        }
        
        do {
            if let url = baseDirectory {
                try FileManager.default.removeItem(at: url)
            }
        } catch {
            print("[ChallengeModel.remove] \(error.localizedDescription)")
            return false
        }
        
        return true
    }
    
    func imagePath(with targetDate: Date, original: Bool = true) -> String? {
        guard let baseDirectory = baseDirectory else {
            return nil
        }
        
        createBaseDirectoryIfNeeded()
        
        let fileName = original ? targetDate.fileName : "\(targetDate.fileName)_thumbnail"
        return baseDirectory.appendingPathComponent("\(fileName).jpg").path
    }

    func image(with targetDate: Date, original: Bool = true) -> UIImage? {
        guard let path = imagePath(with: targetDate, original: original) else {
            return nil
        }
        
        createBaseDirectoryIfNeeded()
        
        return UIImage(contentsOfFile: path)
    }
    
    private func createBaseDirectoryIfNeeded() {
        guard let baseDirectory = baseDirectory else {
            return
        }
        
        let fileManager = FileManager()
        if !fileManager.fileExists(atPath: baseDirectory.path) {
            do {
                try fileManager.createDirectory(atPath: baseDirectory.path, withIntermediateDirectories: false, attributes: nil)
            } catch {
                print("[Challenge.createBaseDirectoryIfNeeded] \(error.localizedDescription)")
                fatalError()
            }
        }
    }
}

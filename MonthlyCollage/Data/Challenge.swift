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
        DataManager.documentDirectory?.appendingPathComponent(id.uuidString, isDirectory: true)
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
        
        guard remove() else {
            return nil
        }
        
        DataManager.shared.achievements.append(achievement)
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
                try FileManager().removeItem(at: url)
            }
        } catch {
            print("[ChallengeModel.remove] \(error.localizedDescription)")
            return false
        }
        return true
    }
    
    func image(with targetDate: Date) -> UIImage? {
        guard let baseDirectory = baseDirectory else {
            return nil
        }
        
        return UIImage(contentsOfFile: baseDirectory.appendingPathComponent("\(targetDate.postfix).jpg").path)
    }
}

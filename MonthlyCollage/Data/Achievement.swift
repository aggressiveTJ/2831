//
//  Achievement.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/26.
//  Copyright © 2020 TJ. All rights reserved.
//

import Foundation
import UIKit

struct Achievement: Identifiable, Equatable, Codable {
    static var fileName = "2831_achievement.dat"
    static let preview = Achievement(challenge: Challenge.preview)
    
    let id: UUID
    let title: String
    let startDate: Date
    
    init(challenge: Challenge) {
        self.id = challenge.id
        self.title = challenge.title
        self.startDate = challenge.startDate
    }
    
    var imagePath: String? {
        guard let achievementDirectory = DataManager.achievementDirectory else {
            return nil
        }
        
        return achievementDirectory.appendingPathComponent("\(id).jpg").path
    }
    var collageImage: UIImage? {
        guard let path = imagePath,
            let image = UIImage(contentsOfFile: path) else {
                return nil
        }
        
        return image
    }
    
    @discardableResult func remove() -> Bool {
        guard let index = DataManager.shared.achievements.firstIndex(of: self) else {
            return false
        }
        
        do {
            if let achievementDirectory = DataManager.achievementDirectory {
                try FileManager().removeItem(at: achievementDirectory)
            }
        } catch {
            print("[AchievementModel.remove] \(error.localizedDescription)")
            return false
        }
        
        DataManager.shared.achievements.remove(at: index)
        return true
    }
}

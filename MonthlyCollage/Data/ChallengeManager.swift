//
//  ChallengeManager.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/25.
//  Copyright © 2020 TJ. All rights reserved.
//

import Foundation
import UIKit

struct ChallengeModel: Identifiable, Equatable, Codable {
    static var fileName = "2831_challenge.dat"
    static let preview = ChallengeModel(title: "Preview")
    
    let id: UUID
    let title: String
    let startDate: Date
    
    init(title: String, startDate: Date = Date()) {
        self.id = UUID()
        self.title = title
        self.startDate = startDate
    }
    
    fileprivate var baseDirectory: URL? {
        ChallengeManager.documentDirectory?.appendingPathComponent(id.uuidString, isDirectory: true)
    }
    
    @discardableResult func register() -> Bool {
        guard !ChallengeManager.shared.challenges.contains(self) else {
            return false
        }
        
        ChallengeManager.shared._challenges.append(self)
        return true
    }
    
    @discardableResult func modify() -> Bool {
        guard let index = ChallengeManager.shared.challenges.firstIndex(of: self) else {
            return false
        }
        
        ChallengeManager.shared._challenges[index] = self
        return true
    }
    
    func complete() -> AcheivementModel? {
        let acheivement = AcheivementModel(challenge: self)
        
        guard remove() else {
            return nil
        }
        
        ChallengeManager.shared.acheivements.append(acheivement)
        return acheivement
    }
    
    @discardableResult func remove() -> Bool {
        guard let index = ChallengeManager.shared.challenges.firstIndex(of: self) else {
            return false
        }
        
        do {
            if let url = baseDirectory {
                try FileManager().removeItem(at: url)
            }
        } catch {
            print("[ChallengeModel.remove] \(error.localizedDescription)")
            return false
        }
        
        ChallengeManager.shared._challenges.remove(at: index)
        return true
    }
    
    func image(with targetDate: Date) -> UIImage? {
        guard let baseDirectory = baseDirectory else {
            return nil
        }
        
        return UIImage(contentsOfFile: baseDirectory.appendingPathComponent("\(targetDate.postfix).jpg").path)
    }
}

struct AcheivementModel: Identifiable, Equatable, Codable {
    static var fileName = "2831_challenge.dat"
    static let preview = AcheivementModel(challenge: ChallengeModel.preview)
    
    let id: UUID
    let title: String
    let startDate: Date
    
    init(challenge: ChallengeModel) {
        self.id = challenge.id
        self.title = challenge.title
        self.startDate = challenge.startDate
    }
    
    fileprivate var baseDirectory: URL? {
        ChallengeManager.documentDirectory?.appendingPathComponent("acheivements", isDirectory: true)
    }
    var collageImage: UIImage? {
        guard let path = baseDirectory?.appendingPathComponent("\(id).jpg").path,
            let image = UIImage(contentsOfFile: path) else {
                return nil
        }
        
        return image
    }
}

final class ChallengeManager {
    static let shared: ChallengeManager = ChallengeManager()
    
    static var documentDirectory: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("2831", isDirectory: true)
    }
    
    private init() { }
    
    fileprivate var _challenges: [ChallengeModel] = [] {
        didSet {
            guard oldValue != challenges,
                let documentDirectory = ChallengeManager.documentDirectory  else {
                    return
            }
            
            sync(_challenges, at: documentDirectory.appendingPathComponent(ChallengeModel.fileName))
        }
    }
    var challenges: [ChallengeModel] {
        _challenges.sorted(by: { $0.startDate > $1.startDate })
    }
    
    fileprivate(set) var acheivements: [AcheivementModel] = [] {
        didSet {
            guard oldValue != acheivements,
                let documentDirectory = ChallengeManager.documentDirectory  else {
                    return
            }
            
            sync(acheivements, at: documentDirectory.appendingPathComponent(AcheivementModel.fileName))
        }
    }
    
    func load() {
        guard let documentDirectory = ChallengeManager.documentDirectory else {
            fatalError()
        }
        
        let fileManager = FileManager()
        
        if !fileManager.fileExists(atPath: documentDirectory.path) {
            do {
                try fileManager.createDirectory(atPath: documentDirectory.path, withIntermediateDirectories: false, attributes: nil)
            } catch {
                print("[ChallengeManager.load] \(error.localizedDescription)")
                fatalError()
            }
        }
        
        do {
            _challenges = try JSONDecoder().decode([ChallengeModel].self, from: try Data(contentsOf: documentDirectory.appendingPathComponent(ChallengeModel.fileName)))
            acheivements = try JSONDecoder().decode([AcheivementModel].self, from: try Data(contentsOf: documentDirectory.appendingPathComponent(AcheivementModel.fileName)))
        } catch {
            print("[ChallengeManager.load] \(error.localizedDescription)")
        }
    }

    private func sync<T: Encodable>(_ items: [T], at path: URL) {
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: path)
        } catch {
            print("[ChallengeManager.sync] \(error.localizedDescription)")
        }
    }
}

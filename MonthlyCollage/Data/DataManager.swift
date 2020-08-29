//
//  DataManager.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/25.
//  Copyright © 2020 TJ. All rights reserved.
//

import Foundation

final class DataManager: ObservableObject {
    static let shared: DataManager = DataManager()
    
    static var appLibraryDirectory: URL? {
        FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first?.appendingPathComponent("2831", isDirectory: true)
    }
    static var achievementDirectory: URL? {
        appLibraryDirectory?.appendingPathComponent("achievements", isDirectory: true)
    }
    
    private init() {
    }
    
    private var _challenges: [Challenge] = [] {
        didSet {
            guard oldValue != _challenges,
                let appLibraryDirectory = DataManager.appLibraryDirectory else {
                    return
            }
            
            sync(_challenges, at: appLibraryDirectory.appendingPathComponent(Challenge.fileName))
        }
    }
    var challenges: [Challenge] {
        get {
            _challenges.sorted(by: { $0.startDate > $1.startDate })
        }
        set {
            _challenges = newValue
        }
    }
    
    private var _achievements: [Achievement] = [] {
        didSet {
            guard oldValue != _achievements,
                let documentDirectory = DataManager.appLibraryDirectory  else {
                    return
            }
            
            sync(achievements, at: documentDirectory.appendingPathComponent(Achievement.fileName))
        }
    }
    var achievements: [Achievement] {
        get {
            _achievements.sorted(by: { $0.startDate > $1.startDate })
        }
        set {
            _achievements = newValue
        }
    }
    
    func load() {
        guard let documentDirectory = DataManager.appLibraryDirectory,
              let achievementDirectory = DataManager.achievementDirectory else {
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
        if !fileManager.fileExists(atPath: achievementDirectory.path) {
            do {
                try fileManager.createDirectory(atPath: achievementDirectory.path, withIntermediateDirectories: false, attributes: nil)
            } catch {
                print("[ChallengeManager.load] \(error.localizedDescription)")
                fatalError()
            }
        }
        
        do {
            _challenges = try JSONDecoder().decode([Challenge].self, from: try Data(contentsOf: documentDirectory.appendingPathComponent(Challenge.fileName)))
            _achievements = try JSONDecoder().decode([Achievement].self, from: try Data(contentsOf: documentDirectory.appendingPathComponent(Achievement.fileName)))
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

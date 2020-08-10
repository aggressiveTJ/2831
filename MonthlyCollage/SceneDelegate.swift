//
//  SceneDelegate.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/08.
//  Copyright © 2020 TJ. All rights reserved.
//

import UIKit
import SwiftUI
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Challenges")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        let context = persistentContainer.viewContext
        let contentView = MCChallengeListView().environment(\.managedObjectContext, context)
        
        loadPreset()

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        saveContext()
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private struct Preset: Codable {
        let id: UUID
        let name: String
        let date: Date
    }
    
    private func loadPreset() {
        let didLoadPresetKey = "didLoadPreset"
        let fileName = "Preset"
        
//        if !UserDefaults.standard.bool(forKey: didLoadPresetKey) {
        if true {
            guard let file = Bundle.main.url(forResource: fileName, withExtension: "plist") else {
                UserDefaults.standard.set(true, forKey: didLoadPresetKey)
                return
            }
            
            let data: Data
            do {
                data = try Data(contentsOf: file)
            } catch {
                fatalError("Couldn't load preset from main bundle:\n\(error)")
            }
            
            let backgroundContext = persistentContainer.newBackgroundContext()
            persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
            
            backgroundContext.perform {
                let presets: [Preset]
                
                do {
                    let decoder = PropertyListDecoder()
                    presets = try decoder.decode([Preset].self, from: data)
                } catch {
                    fatalError("Couldn't parse preset as \([Preset].self):\n\(error)")
                }
                
                do {
                    presets.forEach({
                        let object = Challenge(context: backgroundContext)
                        object.id = $0.id
                        object.name = $0.name
                        object.date = $0.date
                    })
                    
                    try backgroundContext.save()
                    UserDefaults.standard.set(true, forKey: didLoadPresetKey)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}


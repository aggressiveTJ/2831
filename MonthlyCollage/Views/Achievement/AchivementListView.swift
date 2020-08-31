//
//  AchivementListView.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/23.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct AchivementListView: View {
    @EnvironmentObject var manager: DataManager
    
    @State private var groupedByDate = true
    @State private var groupedAchievements: [String: [Achievement]]
    
    private static func groupAchievements(groupByDate: Bool) -> [String: [Achievement]] {
        let grouping = Dictionary(grouping: DataManager.shared.achievements, by: { groupByDate ?  $0.startDate.headerTitle : $0.title }).sorted(by: { $0.key > $1.key })
        return [String: [Achievement]](grouping, uniquingKeysWith: +)
    }
    
    
    init() {
        _groupedAchievements = .init(initialValue: Self.groupAchievements(groupByDate: true))
    }
    
    var body: some View {
        let keys = groupedAchievements.map({ $0.key }).sorted(by: {
            groupedByDate ? ($0 > $1) : ($0 < $1)
        })
        
        return NavigationView(content: {
            List(content: {
                ForEach(keys.indices, id: \.self, content: { (key) in
                    Section(header: Text(keys[key]),
                            content: {
                                ForEach(groupedAchievements[keys[key]] ?? [], content: { (achievement) in
                                    NavigationLink(destination: AchievementDetailView(achievement: achievement), label: {
                                        VStack(content: {
                                            Text(groupedByDate ? achievement.title : achievement.startDate.headerTitle)
                                        })
                                    })
                                })
                                .onDelete(perform: { $0.forEach {
                                    self.delete(at: $0, in: keys[key])
                                }})
                            })
                })
            })
            .navigationBarTitle(Text("Achievements"))
            .navigationBarItems(trailing: sortButton)
        })
    }
    
    private func delete(at index: Int, in key: String) {
        guard let removed = self.groupedAchievements[key]?[index] else {
            return
        }
        
        removed.remove()
        groupedAchievements = Self.groupAchievements(groupByDate: groupedByDate)
    }

    private var sortButton: some View {
        Button(action: {
            groupedByDate.toggle()
            groupedAchievements = Self.groupAchievements(groupByDate: groupedByDate)
        }, label: {
            if groupedByDate {
                Image(systemName: "calendar.circle")
                    .imageScale(.large)
            } else {
                Image(systemName: "a.circle")
                    .imageScale(.large)
            }
        })
    }
}

struct AchivementListView_Previews: PreviewProvider {
    static var previews: some View {
        AchivementListView()
            .environmentObject(DataManager.shared)
    }
}

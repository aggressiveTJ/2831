//
//  MCOmakeListView.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/23.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct MCOmakeListView: View {
    @State private var dataSource = AchievementDataSource<Achievement>()
    @State var isPresented = false
    
    private var months: [String: [Achievement]] {
        Dictionary(grouping: dataSource.objects) { $0.date.headerTitle }
    }
    
    var body: some View {
        let keys = months.map { $0.key }
        
        return NavigationView(content: {
            List(content: {
                ForEach(keys.indices, content: { (key) in
                    Section(header: Text(keys[key]),
                            content: {
                                ForEach(months[keys[key]] ?? [], content: { (achievement) in
                                    NavigationLink(destination: MCOmakeDetailView(achievement: achievement), label: {
                                        Text(achievement.name)
                                    })
                                })
                                .onDelete(perform: removeAchievement)
                            })
                })
            })
            .navigationBarTitle(Text("Achievement"))
        })
    }
    
    func removeAchievement(at offsets: IndexSet) {
        offsets.forEach { (index) in
            let achievement = dataSource.objects[index]
            achievement.delete()
        }
    }
}

struct MCOmakeListView_Previews: PreviewProvider {
    static var previews: some View {
        MCOmakeListView()
    }
}

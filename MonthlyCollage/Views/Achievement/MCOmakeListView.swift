//
//  MCOmakeListView.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/23.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct MCOmakeListView: View {
    @EnvironmentObject var manager: DataManager
    @State private var groupedByDate = true
    
    private var months: [String: [Achievement]] {
        let grouping = Dictionary(grouping: manager.achievements, by: { groupedByDate ? $0.startDate.headerTitle : $0.title }).sorted(by: { $0.key > $1.key })
        return [String: [Achievement]](grouping, uniquingKeysWith: +)
    }
    
    var body: some View {
        let keys = months.map({ $0.key })
        
        return NavigationView(content: {
            List(content: {
                ForEach(keys.indices, content: { (key) in
                    Section(header: Text(keys[key]),
                            content: {
                                ForEach(months[keys[key]] ?? [], content: { (achievement) in
                                    NavigationLink(destination: MCOmakeDetailView(achievement: achievement), label: {
                                        VStack(content: {
                                            Text(achievement.title)
                                        })
                                    })
                                })
                                .onDelete(perform: { $0.forEach { manager.achievements.remove(at: $0) }})
                            })
                })
            })
            .navigationBarTitle(Text("Achievement"))
            .navigationBarItems(trailing: sortButton)
        })
    }

    private var sortButton: some View {
        Button(action: {
            self.groupedByDate.toggle()
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

struct MCOmakeListView_Previews: PreviewProvider {
    static var previews: some View {
        MCOmakeListView()
            .environmentObject(DataManager.shared)
    }
}

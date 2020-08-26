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
    @State var isPresented = false
    
    private var months: [String: [Achievement]] {
        Dictionary(grouping: manager.achievements) { $0.startDate.headerTitle }
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
                                        Text(achievement.title)
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
    }
}

struct MCOmakeListView_Previews: PreviewProvider {
    static var previews: some View {
        MCOmakeListView()
            .environmentObject(DataManager.shared)
    }
}

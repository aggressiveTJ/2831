//
//  MainTabView.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/11.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var manager: DataManager
    @State private var selectedTabIndex: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTabIndex, content: {
            ChallengeListView()
                .tabItem({
                    Image(systemName: "calendar")
                    Text("Challenges")
                })
                .tag(0)
            
            AchivementListView()
                .tabItem({
                    Image(systemName: "square.grid.4x3.fill")
                    Text("Achievements")
                })
                .tag(1)
        })
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(DataManager.shared)
    }
}

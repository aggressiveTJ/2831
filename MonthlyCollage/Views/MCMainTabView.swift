//
//  MCMainTabView.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/11.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct MCMainTabView: View {
    @State private var selectedTabIndex: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTabIndex, content: {
            MCChallengeListView()
                .tabItem({
                    Image(systemName: "calendar")
                    Text("Challenges")
                })
                .tag(0)
            
            EmptyView()
                .tabItem({
                    Image(systemName: "square.grid.4x3.fill")
                    Text("Omake")
                })
                .tag(1)
        })
    }
}

struct MCMainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MCMainTabView()
    }
}

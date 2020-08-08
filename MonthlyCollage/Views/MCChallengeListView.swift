//
//  MCChallengeListView.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/08.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct MCChallengeListView: View {
    @State var showingAddView = false
    
    let challenges = ["a", "b", "c"]
    
    var body: some View {
        NavigationView(content: {
            List(content: {
                ForEach(challenges, id: \.self, content: { (challenge) in
                    NavigationLink(destination: MCCalendarView(date: Date()), label: {
                        Text(challenge)
                    })
                })
            })
                .navigationBarTitle(Text("Challenge"))
                .navigationBarItems(trailing: Button(action: {
                    self.showingAddView.toggle()
                }, label: {
                    Image(systemName: "plus.circle")
                }))
                .sheet(isPresented: $showingAddView, content: {
                    MCAddChallengeView(challengeName: .constant(self.challenges[0]))
                })
        })
    }
}

struct MCChallengeListView_Previews: PreviewProvider {
    static var previews: some View {
        MCChallengeListView()
    }
}

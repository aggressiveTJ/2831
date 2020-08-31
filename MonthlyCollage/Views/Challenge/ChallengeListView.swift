//
//  ChallengeListView.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/08.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct ChallengeListView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showsSheet = false
    @State private var groupedChallenge: [String: [Challenge]]
    
    private static func groupChallenges() -> [String: [Challenge]] {
        let grouping = Dictionary(grouping: DataManager.shared.challenges, by: { $0.startDate.headerTitle }).sorted(by: { $0.key > $1.key })
        return [String: [Challenge]](grouping, uniquingKeysWith: +)
    }
    
    init() {
        _groupedChallenge = .init(initialValue: Self.groupChallenges())
    }
    
    var body: some View {
        let keys = groupedChallenge.map({ $0.key }).sorted(by: >)
        
        return NavigationView(content: {
            List(content: {
                ForEach(keys.indices, id: \.self, content: { (key) in
                    Section(header: Text(keys[key]),
                            content: {
                                ForEach(groupedChallenge[keys[key]] ?? [], content: { (challenge) in
                                    ChallengeListRow(challenge: challenge)
                                })
                                .onDelete(perform: { $0.forEach {
                                    self.delete(at: $0, in: keys[key])
                                }})
                            })
                })
            })
            .navigationBarTitle(Text("Challenges"))
            .navigationBarItems(trailing: Button(action: {
                self.showsSheet.toggle()
            }, label: {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
            }))
            .sheet(isPresented: $showsSheet, content: {
                AddChallengeView()
                    .onDisappear(perform: {
                        self.groupedChallenge = Self.groupChallenges()
                    })
            })
        })
    }
    
    private func delete(at index: Int, in key: String) {
        guard let removed = self.groupedChallenge[key]?[index] else {
            return
        }
        
        removed.remove()
        groupedChallenge = Self.groupChallenges()
    }
}

struct ChallengeListView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeListView()
    }
}

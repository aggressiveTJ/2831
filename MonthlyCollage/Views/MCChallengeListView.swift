//
//  MCChallengeListView.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/08.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI
import CoreData

struct MCChallengeListView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var dataSource = ChallengeDataSource<Challenge>()
    @State var isPresented = false
    
    private var months: [String: [Challenge]] {
        Dictionary(grouping: dataSource.objects) { $0.date.headerTitle }
    }
    
    var body: some View {
        let keys = months.map { $0.key }
        
        return NavigationView(content: {
            List(content: {
                ForEach(keys.indices, content: { (key) in
                    Section(header: Text(keys[key]),
                            content: {
                                ForEach(months[keys[key]] ?? [], content: { (challenge) in
                                    NavigationLink(destination: MCChallengeDetailView(challenge: challenge), label: {
                                        MCChallengeListRow(challenge: challenge)
                                    })
                                })
                                .onDelete(perform: removeChallenge)
                            })
                })
            })
            .navigationBarTitle(Text("Challenges"))
            .navigationBarItems(trailing: Button(action: {
                self.isPresented.toggle()
            }, label: {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
            }))
            .sheet(isPresented: $isPresented, content: {
                MCAddChallengeView()
            })
        })
    }
    
    func removeChallenge(at offsets: IndexSet) {
        offsets.forEach { (index) in
            let challenge = dataSource.objects[index]
            challenge.delete()
        }
    }
}

struct MCChallengeListView_Previews: PreviewProvider {
    static var previews: some View {
        MCChallengeListView()
    }
}

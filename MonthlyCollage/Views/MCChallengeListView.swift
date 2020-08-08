//
//  MCChallengeListView.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/08.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct MCChallengeListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Challenge.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Challenge.name, ascending: true)])
    var challenges: FetchedResults<Challenge>

    @State var isPresented = false
    
    var body: some View {
        NavigationView(content: {
            List(content: {
                ForEach(challenges, id: \.self, content: { (challenge) in
                    NavigationLink(destination: MCChallengeDetailView(challenge: challenge), label: {
                        MCChallengeListRow(challenge: challenge)
                    })
                })
                    .onDelete(perform: removeChallenge)
            })
                .navigationBarTitle(Text("Challenges"))
                .navigationBarItems(trailing: Button(action: {
                    self.isPresented.toggle()
                }, label: {
                    Image(systemName: "plus.circle")
                }))
                .sheet(isPresented: $isPresented, content: {
                    MCAddChallengeView(onComplete: { (id, name, date) in
                        self.addChallenge(name: name)
                        self.isPresented = false
                    })
                })
        })
    }
    
    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    func addChallenge(name: String) {
        let challenge = Challenge(context: managedObjectContext)
        
        challenge.id = UUID()
        challenge.name = name
        challenge.date = Date()

        saveContext()
    }
    
    func removeChallenge(at offsets: IndexSet) {
        offsets.forEach { (index) in
            let challenge = challenges[index]
            self.managedObjectContext.delete(challenge)
        }
        
        saveContext()
    }
}

struct MCChallengeListView_Previews: PreviewProvider {
    static var previews: some View {
        MCChallengeListView()
    }
}

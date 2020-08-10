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
    @Environment(\.presentationMode) var presentationMode

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
                    MCAddChallengeView(Challenge.empty, completion: {
                        if $0.isVaild {
                            self.addChallenge($0)
                        }
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
    
    func addChallenge(_ challenge: Challenge) {
        let object = Challenge(context: managedObjectContext)
        
        object.id = challenge.id
        object.name = challenge.name
        object.date = challenge.date ?? Date()

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
        let context = (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).persistentContainer.viewContext
        return MCChallengeListView()
            .environment(\.managedObjectContext, context)
    }
}

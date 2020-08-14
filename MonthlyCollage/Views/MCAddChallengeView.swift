//
//  MCAddChallengeView.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/08.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct MCAddChallengeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var id: UUID
    @State var name: String
    @State var date: Date
    
    var challenge: Challenge?
    
    init(_ challenge: Challenge? = nil) {
        self.challenge = challenge
        
        _id = State(initialValue: challenge?.id ?? UUID())
        _name = State(initialValue: challenge?.name ?? "")
        _date = State(initialValue: challenge?.date ?? Date())
    }
    
    var body: some View {
        let navigationBarTitle = (challenge != nil) ? "Edit Challenge" : "Add New Challenge"
        
        return NavigationView(content: {
            Form(content: {
                Text(id.uuidString)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Section(header: Text("Title"), content: {
                    TextField("Title", text: $name)
                })
                
                Section(header: Text("Start Date"), content: {
                    DatePicker(selection: $date, displayedComponents: .date, label: {
                        EmptyView()
                    })
                })
            })
            .navigationBarTitle(Text(navigationBarTitle), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: addAction, label: {
                Text("Done")
            }))
        })
    }
    
    private func addAction() {
        presentationMode.wrappedValue.dismiss()
        
        guard !name.isEmpty else {
            return
        }
        
        if challenge != nil {
            challenge?.update(name: name)
            challenge?.update(date: date)
        } else {
            _ = Challenge.createChallenge(name: name, id: id, date: date)
        }
    }
}

struct MCAddChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        MCAddChallengeView(Challenge.preview())
    }
}


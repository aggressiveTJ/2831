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
    
    let challenge: Challenge?
    let onComplete: ((Challenge) -> Void)
    
    var isEditing: Bool {
        challenge?.id != nil
    }
    
    init(_ challenge: Challenge, completion: @escaping ((Challenge) -> Void)) {
        self.challenge = challenge
        self.onComplete = completion
        
        _id = State(initialValue: challenge.id ?? UUID())
        _name = State(initialValue: challenge.name ?? "")
        _date = State(initialValue: challenge.date ?? Date())
    }
    
    var body: some View {
        let navigationBarTitle = isEditing ? "Edit Challenge" : "Add New Challenge"
        
        return NavigationView(content: {
            Form(content: {
                Text(id.uuidString)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Section(header: Text("Title"), content: {
                    TextField("Title", text: $name)
                })
                
                Section(content: {
                    DatePicker(selection: $date, label: {
                        Text("Start Date")
                    })
                })
                
                Section(content: {
                    Button(action: addAction, label: {
                        Text("Done")
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
        let edited = challenge ?? Challenge.empty
        edited.id = id
        edited.name = name
        edited.date = date

        onComplete(edited)
        presentationMode.wrappedValue.dismiss()
    }
}

struct MCAddChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        let challenge = Challenge.empty
        challenge.id = UUID()
        challenge.name = "Preview"
        challenge.date = Date()
        
        return MCAddChallengeView(challenge, completion: { (_) in })
    }
}


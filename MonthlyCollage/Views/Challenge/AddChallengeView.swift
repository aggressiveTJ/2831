//
//  AddChallengeView.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/08.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct AddChallengeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var id: UUID
    @State var title: String
    @State var startDate: Date
    
    var challenge: Challenge?
    
    init(challenge: Challenge? = nil) {
        self.challenge = challenge
        
        _id = State(initialValue: challenge?.id ?? UUID())
        _title = State(initialValue: challenge?.title ?? "")
        _startDate = State(initialValue: challenge?.startDate ?? Date())
    }
    
    var body: some View {
        let navigationBarTitle = (challenge != nil) ? "Edit Challenge" : "Add New Challenge"
        
        return NavigationView(content: {
            Form(content: {
                Text(id.uuidString)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Section(header: Text("Title"), content: {
                    TextField("Title", text: $title)
                })
                
                Section(header: Text("Start Date"), content: {
                    DatePicker(selection: $startDate, displayedComponents: .date, label: {
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
        
        guard !title.isEmpty else {
            return
        }

        if let editedChallenge = challenge {
            editedChallenge.modify()
        } else {
            Challenge(title: title, startDate: startDate).register()
        }
    }
}

struct AddChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        AddChallengeView(challenge: Challenge.preview)
    }
}


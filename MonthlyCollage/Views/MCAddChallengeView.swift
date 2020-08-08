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

    @State var id = UUID()
    @State var name = ""
    @State var date = Date()
    
    let onComplete: ((UUID, String, Date) -> Void)
    
    var body: some View {
        NavigationView(content: {
            Form(content: {
                Text(id.uuidString)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Section(header: Text("Title"), content: {
                    TextField("Title", text: $name)
                })
                
            })
                .navigationBarTitle(Text("Add New Challenge"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: addAction, label: {
                    Text("Add")
                }))
        })
    }

    private func addAction() {
        onComplete(id, (name.isEmpty ? "Challenge \(date)" : name), date)
    }
}

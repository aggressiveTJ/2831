//
//  MCChallengeDetailView.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/08.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct MCChallengeDetailView: View {
    @EnvironmentObject var manager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showsActionSheet = false
    @State private var showsEditView = false

    let challenge: Challenge
    
    var body: some View {
        ScrollView(content: {
            VStack(alignment: .leading, spacing: 5, content: {
                Text(challenge.id.uuidString)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Divider()
                Spacer(minLength: 30)
                
                MCCalendarView(challenge: challenge)
                
                Button(action: {
                    if let _ = challenge.complete()?.collageImage {
                        self.presentationMode.wrappedValue.dismiss()
                    } else {
                        print("[MCChallengeDetailView.body] smt wrong")
                    }
                }, label: {
                    Text("Export Collage")
                })
            })
            .padding()
        })
        .navigationBarTitle(Text(challenge.title))
        .navigationBarItems(trailing: moreButton)
        .sheet(isPresented: $showsEditView, content: {
            MCAddChallengeView(challenges: $manager.challenges, challenge: challenge)
        })
    }
    
    private var moreButton: some View {
        Button(action: {
            self.showsActionSheet = true
        }, label: {
            Image(systemName: "ellipsis.circle")
                .imageScale(.large)
        })
        .actionSheet(isPresented: $showsActionSheet, content: {
            ActionSheet(title: Text(""), buttons: [
                .default(Text("Edit"), action: {
                    self.showsEditView.toggle()
                }),
                .default(Text("Remove"), action: {
                    self.challenge.remove()
                    self.presentationMode.wrappedValue.dismiss()
                }),
                .cancel()
            ])
        })
    }
}

struct MCChallengeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MCChallengeDetailView(challenge: Challenge.preview)
            MCChallengeDetailView(challenge: Challenge.preview)
                .preferredColorScheme(.dark)
        }
    }
}

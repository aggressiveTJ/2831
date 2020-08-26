//
//  MCChallengeDetailView.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/08.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct MCChallengeDetailView: View {
    @State private var showsActionSheet = false
    @Environment(\.presentationMode) var presentationMode

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
                        print("smt wrong")
                    }
                }, label: {
                    Text("Export Collage")
                })
            })
            .padding()
        })
        .navigationBarTitle(Text(challenge.title))
        .navigationBarItems(trailing: moreButton)
    }
    
    private var moreButton: some View {
        Button(action: {
            self.showsActionSheet = true
        }, label: {
            Image(systemName: "ellipsis.circle")
                .imageScale(/*@START_MENU_TOKEN@*/.large/*@END_MENU_TOKEN@*/)
        })
        .actionSheet(isPresented: $showsActionSheet, content: {
            ActionSheet(title: Text(""), buttons: [
                .default(Text("Edit"), action: {}),
                .destructive(Text("Remove"), action: {}),
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

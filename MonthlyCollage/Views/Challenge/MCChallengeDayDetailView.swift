//
//  MCChallengeDayDetailView.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/29.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct MCChallengeDayDetailView: View {
    @State private var showsSheet = false
    
    let challenge: Challenge
    let day: Day
    
    var body: some View {
        VStack(content: {
            if let sharableImage = day.sharableImage {
                Image(uiImage: sharableImage)
                    .resizable()
            }
        })
        .navigationBarTitle(Text(day.date.exifDateString))
        .navigationBarItems(trailing: Button(action: {
            self.showsSheet = true
        }, label: {
            Image(systemName: "square.and.arrow.up")
                .imageScale(.large)
        }))
        .sheet(isPresented: $showsSheet, content: {
            ActivityViewController(activityItems: [day.sharableImage])
        })
    }
}

struct MCChallengeDayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MCChallengeDayDetailView(challenge: Challenge.preview, day: Day(date: Date(), uiImage: UIImage(systemName: "question.square")))
    }
}

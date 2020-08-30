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
    @State private var viewTitle: String
    @State private var selection: Int

    let challenge: Challenge
    let day: Day
    let length = UIScreen.main.fixedCoordinateSpace.bounds.width
    
    init(challenge: Challenge, day: Day) {
        self.challenge = challenge
        self.day = day
        
        _viewTitle = .init(initialValue: day.date.exifDateString)
        _selection = .init(initialValue: challenge.days.firstIndex(of: day) ?? 0)
    }
    
    var body: some View {
        VStack(content: {
            TabView(selection: $selection, content: {
                ForEach(challenge.days, content: { (day) in
                    VStack(content: {
                        if let image = day.originalImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .padding()
                        }
                    })
                    .frame(width: length, height: length)
                })
            })
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            Spacer()
        })
        .navigationBarTitle(viewTitle, displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.showsSheet = true
        }, label: {
            Image(systemName: "square.and.arrow.up")
                .imageScale(.large)
        }))
        .sheet(isPresented: $showsSheet, content: {
            ActivityViewController(activityItems: [day.sharableImage()])
        })
    }
}

struct MCChallengeDayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MCChallengeDayDetailView(challenge: Challenge.preview, day: Day(date: Date(), in: Challenge.preview))
    }
}

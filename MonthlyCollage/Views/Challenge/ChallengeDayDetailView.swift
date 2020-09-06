//
//  ChallengeDayDetailView.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/29.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct ChallengeDayDetailView: View {
    @State private var showsSheet = false
    @State private var viewTitle: String
    @State private var selection: Int

    let challenge: Challenge
    let day: Day
    let length = UIScreen.main.fixedCoordinateSpace.bounds.width - 30
    
    init(challenge: Challenge, day: Day) {
        self.challenge = challenge
        self.day = day
        
        _viewTitle = .init(initialValue: challenge.title)
        _selection = .init(initialValue: challenge.days.firstIndex(of: day) ?? 0)
    }
    
    var body: some View {
        VStack(content: {
            TabView(selection: $selection, content: {
                ForEach(challenge.days, content: { (day) in
                    VStack(content: {
                        Text(day.date.exifDateString)
                            .font(.title2)
                            .fontWeight(.ultraLight)
                            .multilineTextAlignment(.center)
                            
                        if let image = day.originalImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: length, height: length)
                                .cornerRadius(8)
                                .padding()
                        } else {
                            VStack(alignment: .center, content: {
                                Image(systemName: "plus")
                                    .imageScale(.large)
                                    .foregroundColor(.gray)
                            })
                            .frame(width: length, height: length)
                            .overlay(RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1))
                            .padding()
                        }
                    })
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
            ActivityViewController(activityItems: [challenge.days[selection].sharableImage()])
        })
    }
}

struct ChallengeDayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDayDetailView(challenge: Challenge.preview, day: Day(date: Date(), in: Challenge.preview))
    }
}

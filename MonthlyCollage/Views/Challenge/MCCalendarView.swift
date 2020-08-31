//
//  MCCalendarView.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/08.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct MCCalendarView: View {
    @Environment(\.calendar) var calendar
    @Binding var selectedDay: Day?
    
    private let gridItemLayout = Array(repeating: GridItem(.flexible(minimum: 10, maximum: (UIScreen.main.fixedCoordinateSpace.bounds.width / 8))), count: 7)

    let challenge: Challenge
    var days: [Day] {
        challenge.days
    }
    
    private var numberOfBlanks: Int {
        calendar.component(.weekday, from: days[0].date) - 1
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5, content: {
            headerView
            
            LazyVGrid(columns: gridItemLayout, content: {
                ForEach(0..<numberOfBlanks, content: { (_) in
                    Text("0")
                        .hidden()
                })
                
                ForEach(days, id: \.self, content: { (day) in
                    LazyView(DayView(day: day, challenge: challenge, action: { (selectedDay) in
                        self.selectedDay = selectedDay
                    }))
                })
            })
            .id(UUID())

            Divider()
        })
    }
    
    private var headerView: some View {
        VStack(alignment: .center, spacing: 5, content: {
            Text(challenge.startDate.headerTitle)
                .font(.largeTitle)
                .fontWeight(.ultraLight)
                .padding(.bottom)
            
            Divider()
            
            LazyVGrid(columns: gridItemLayout, content: {
                ForEach(calendar.shortWeekdaySymbols.map({ $0.uppercased() }), id: \.self, content: { (string) in
                    Text(string)
                        .font(.caption)
                        .fontWeight(.bold)
                })
            })
            
            Divider()
                .padding(.bottom, 10)
        })
    }
}

struct DayView: View {
    @Environment(\.calendar) var calendar
    
    @State private var image: Image?

    let day: Day
    let challenge: Challenge
    var action: ((Day) -> Void)?
    
    private var isAvailable: Bool {
        day.date <= Date()
    }
    
    var body: some View {
        ZStack(content: {
            if isAvailable {
                image?
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.8)
                    .layoutPriority(-1)
                
                if day.hasImages {
                    NavigationLink(
                        destination: MCChallengeDayDetailView(challenge: challenge, day: day),
                        label: {
                            VStack(content: {
                                Text(String(calendar.component(.day, from: day.date)))
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .foregroundColor(.white)
                                    .background(Color.black.opacity(0.7))
                                    .opacity(0.7)
                                    .shadow(radius: 1)
                            })
                        })
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .buttonStyle(PlainButtonStyle())
                } else {
                    Button(action: {
                        self.action?(self.day)
                    }, label: {
                        VStack(alignment: .leading, content: {
                            Text(String(calendar.component(.day, from: day.date)))
                                .font(.body)
                                .fontWeight(.thin)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .overlay(RoundedRectangle(cornerRadius: 3)
                                            .stroke(Color.gray, lineWidth: 0.5))
                        })
                    })
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .buttonStyle(PlainButtonStyle())
                }
            } else {
                Text(String(calendar.component(.day, from: day.date)))
                    .font(.body)
                    .fontWeight(.ultraLight)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .opacity(0.3)
            }
        })
        .clipShape(RoundedRectangle(cornerRadius: 3))
        .clipped()
        .onAppear(perform: {
            if let image = day.thumbnailImage {
                self.image = Image(uiImage: image)
            }
        })
    }
}

struct MCCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MCCalendarView(selectedDay: .constant(nil), challenge: Challenge.preview)
    }
}

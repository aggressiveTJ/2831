//
//  MCCalendarView.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/08.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

private extension Calendar {
    func generateDates(inside interval: DateInterval, matching components: DateComponents) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)
        
        enumerateDates(startingAfter: interval.start, matching: components, matchingPolicy: .nextTime, using: { (date, _, stop) in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        })
        return dates
    }
}

struct MCCalendarView: View {
    @Environment(\.calendar) var calendar
    
    private let gridItemLayout = Array(repeating: GridItem(.flexible(minimum: 10, maximum: (UIScreen.main.fixedCoordinateSpace.bounds.width / 8))), count: 7)
    
    let challenge: Challenge
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5, content: {
            headerView
            calendarView
            
            Divider()
        })
    }
    
    private var headerView: some View {
        VStack(alignment: .center, spacing: 5, content: {
            Text(challenge.date.headerTitle)
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
        })
    }
    
    private var calendarView: some View {
        let days: [Date] = {
            guard let monthInterval = calendar.dateInterval(of: .month, for: challenge.date) else {
                return []
            }
            
            return calendar.generateDates(inside: monthInterval, matching: DateComponents(hour: 0, minute: 0, second: 0))
        }()
        
        var numberOfBlanks: Int {
            calendar.component(.weekday, from: days[0]) - 1
        }
        
        return LazyVGrid(columns: gridItemLayout, content: {
            ForEach(0..<numberOfBlanks, content: { (_) in
                Text("0")
                    .hidden()
            })
            
            ForEach(days, id: \.self, content: { (day) in
                DayView(challenge: challenge, date: day)
            })
        })
    }
}

private struct DayView: View {
    @Environment(\.calendar) var calendar
    @State var showingImagePicker = false
    
    let challenge: Challenge
    
    private let date: Date
    private var image: Image?
    private var isAvailable: Bool {
        date <= Date()
    }
    
    init(challenge: Challenge, date: Date = Date()) {
        self.challenge = challenge
        self.date = date
        
        if let uiImage = challenge.image(with: date) {
            self.image = Image(uiImage: uiImage)
        }
    }
    
    var body: some View {
        ZStack(content: {
            if isAvailable {
                image?
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.8)
                    .layoutPriority(-1)
                    .clipShape(RoundedRectangle(cornerRadius: 3))
                    .clipped()
                
                Button(action: {
                    self.showingImagePicker = true
                }, label: {
                    if challenge.isComplete(with: date) {
                        VStack(content: {
                            Text(String(calendar.component(.day, from: date)))
                                .font(.body)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding(.top, 15)
                                .padding(.bottom, 10)
                                .foregroundColor(.white)
                                .background(Color.black.opacity(0.7))
                                .opacity(0.7)
                                .shadow(radius: 1)
                        })
                    } else {
                        VStack(alignment: .leading, content: {
                            Text(String(calendar.component(.day, from: date)))
                                .font(.body)
                                .fontWeight(.thin)
                                .frame(maxWidth: .infinity)
                                .padding(.top, 15)
                                .padding(.bottom, 10)
                        })
                    }
                })
                .frame(maxWidth: .infinity)
                .overlay(RoundedRectangle(cornerRadius: 3)
                            .stroke(Color.gray, lineWidth: 0.5))
                .buttonStyle(PlainButtonStyle())
            } else {
                Text(String(calendar.component(.day, from: date)))
                    .font(.body)
                    .fontWeight(.ultraLight)
                    .padding(.top, 15)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity)
                    .opacity(0.3)
            }
        })
        .clipped()
        .sheet(isPresented: $showingImagePicker, content: {
            if isAvailable {
                ImagePicker(sourceType: .savedPhotosAlbum, onImagePicked: { (image) in
                    _ = image.save(in: challenge.imagePath(with: date))
                })
            }
        })
    }
}

struct MCCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MCCalendarView(challenge: Challenge.preview())
    }
}

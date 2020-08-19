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

    var date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5, content: {
            headerView
            calendarView
            
            Divider()
        })
        .padding()
    }
    
    private var headerView: some View {
        VStack(alignment: .center, spacing: 5, content: {
            Text(DateFormatter.monthAndYear.string(from: date))
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
            guard let monthInterval = calendar.dateInterval(of: .month, for: date) else {
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
                DayView(date: day)
            })
        })
    }
}

private struct DayView: View {
    @Environment(\.calendar) var calendar
    @State var showingImagePicker = false
    
    private let date: Date
    private var image: Image?
    private var isAvailable: Bool {
        date <= Date()
    }
    
    init(date: Date = Date()) {
        self.date = date
    }
    
    var body: some View {
        ZStack(content: {
            if isAvailable {
                image?
                    .resizable()
                
                Button(action: {
                    self.showingImagePicker = true
                }, label: {
                    Text(String(calendar.component(.day, from: date)))
                        .font(.body)
                        .fontWeight(.thin)
                        .foregroundColor(.black)
                })
                .padding(.vertical)
                .frame(maxWidth: .infinity)
            } else {
                Text(String(calendar.component(.day, from: date)))
                    .font(.body)
                    .fontWeight(.thin)
                    .foregroundColor(.gray)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
            }
            
        })
        .sheet(isPresented: $showingImagePicker, content: {
            if isAvailable {
                ImagePicker(sourceType: .savedPhotosAlbum, onImagePicked: { (image) in
                    
                })
            }
        })
    }
}

struct MCCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MCCalendarView(date: Date(timeInterval: 0, since: Date()))
    }
}

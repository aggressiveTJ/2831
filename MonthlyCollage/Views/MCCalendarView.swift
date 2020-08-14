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

private struct weekView: View {
    @Environment(\.calendar) var calendar
    
    let date: Date
    let week: Date
    
    init(_ date: Date, week: Date) {
        self.date = date
        self.week = week
    }
    
    private var days: [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week) else {
            return []
        }
        
        return calendar.generateDates(inside: weekInterval, matching: DateComponents(hour: 0, minute: 0, second: 0))
    }
    
    var body: some View {
        HStack(content: {
            ForEach(days, id: \.self, content: { (day) in
                HStack {
                    if self.calendar.isDate(self.date, equalTo: day, toGranularity: .month) {
                        self.dayText(from: day)
                            .frame(width: 45, height: 45)
                    } else {
                        self.dayText(from: day)
                            .frame(width: 45, height: 45)
                            .hidden()
                    }
                }
            })
        })
    }
    
    private func dayText(from date: Date) -> Text {
        Text(String(calendar.component(.day, from: date)))
            .font(.body)
            .fontWeight(.thin)
    }
}

struct MCCalendarView: View {
    @Environment(\.calendar) var calendar
    
    let gridItemLayout = Array(repeating: GridItem(.fixed(45)), count: 7)

    var date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5, content: {
            headerView
            calendarView
            
            Divider()
        })
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
                        .frame(width: 45.0)
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
                Text(String(calendar.component(.day, from: day)))
                    .font(.body)
                    .fontWeight(.thin)
                    .frame(width: 45.0)
                    .padding(.vertical)
            })
        })
    }
}

struct MCCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MCCalendarView(date: Date(timeInterval: 0, since: Date()))
    }
}

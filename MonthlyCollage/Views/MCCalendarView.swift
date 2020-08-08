//
//  MCCalendarView.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/08.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

fileprivate extension DateFormatter {
    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM"
        return formatter
    }
}

fileprivate extension Calendar {
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
    
    var date: Date
    
    var body: some View {
        ScrollView(content: {
            VStack(alignment: .leading, spacing: 5, content: {
                headerView
                calendarView
                
                Divider()
                Spacer(minLength: 50)
                
                Button(action: {
                }, label: {
                    HStack(content: {
                        Image(systemName: "pencil.circle")
                        Text("Edit")
                            .fontWeight(.semibold)
                    })
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .foregroundColor(.green)
                })
                
                Button(action: {
                }, label: {
                    HStack(content: {
                        Image(systemName: "trash.circle")
                        Text("Remove")
                            .fontWeight(.semibold)
                    })
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .foregroundColor(.red)
                        .opacity(0.5)
                })
            })
                .padding()
        })
            .navigationBarTitle(Text("Challenge Name"))
    }
    
    private let dayHeaderString = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    
    private var headerView: some View {
        VStack(alignment: .center, spacing: 5, content: {
            Text(DateFormatter.monthAndYear.string(from: date))
                .font(.largeTitle)
                .fontWeight(.ultraLight)
                .padding(.bottom)
                
            Divider()
                .padding(.horizontal)

            HStack(alignment: .center, content: {
                ForEach(dayHeaderString, id: \.self, content: { (string) in
                    Text(string)
                        .font(.caption)
                        .fontWeight(.bold)
                        .frame(width: 45.0)
                })
            })
                
            Divider()
                .padding(.horizontal)
        })
    }
    
    private var calendarView: some View {
        let interval = calendar.dateInterval(of: .month, for: date) ?? DateInterval()
        let weeks = calendar.generateDates(inside: interval, matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday))
    
        return VStack(content: {
            ForEach(weeks, id: \.self, content: { (week) in
                weekView(self.date, week: week)
            })
        })
    }
}

struct MCCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        let date = Date(timeInterval: 0, since: Date())
        return MCCalendarView(date: date)
    }
}

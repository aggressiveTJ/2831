//
//  MCCalendarView.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/08.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct Day: Equatable, Hashable {
    let date: Date
    var uiImage: UIImage?
    
    init(date: Date, uiImage: UIImage? = nil) {
        self.date = date
        self.uiImage = uiImage
    }
    
    var image: Image? {
        guard let uiImage = uiImage else {
            return nil
        }
        
        return Image(uiImage: uiImage)
            .resizable()
    }
}

struct MCCalendarView: View {
    @Environment(\.calendar) var calendar
    @State var days: [Day]
    
    private let gridItemLayout = Array(repeating: GridItem(.flexible(minimum: 10, maximum: (UIScreen.main.fixedCoordinateSpace.bounds.width / 8))), count: 7)

    
    let challenge: ChallengeModel
    
    init(challenge: ChallengeModel) {
        self.challenge = challenge
        
        guard let interval = Calendar.current.dateInterval(of: .month, for: challenge.startDate) else {
            _days = State(initialValue: [])
            return
        }
        
        var days: [Day] = [Day(date: interval.start, uiImage: challenge.image(with: interval.start))]
        Calendar.current.enumerateDates(startingAfter: interval.start, matching: DateComponents(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime, using: { (date, _, stop) in
            if let date = date {
                if date < interval.end {
                    days.append(Day(date: date, uiImage: challenge.image(with: date)))
                } else {
                    stop = true
                }
            }
        })
        
        print(days)
        _days = State(initialValue: days)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5, content: {
            headerView
            calendarView
            
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
    
    private var calendarView: some View {
        var numberOfBlanks: Int {
            calendar.component(.weekday, from: days[0].date) - 1
        }
        
        return LazyVGrid(columns: gridItemLayout, content: {
            ForEach(0..<numberOfBlanks, content: { (_) in
                Text("0")
                    .hidden()
            })
            
            ForEach(days, id: \.self, content: { (day) in
                DayView(days: $days, day: day)
            })
        })
    }
}

private struct DayView: View {
    @Environment(\.calendar) var calendar
    @State var showingImagePicker = false
    @Binding var days: [Day]
    
    let day: Day
    
    private var isAvailable: Bool {
        day.date <= Date()
    }
    
    var body: some View {
        ZStack(content: {
            if isAvailable {
                day.image?
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.8)
                    .layoutPriority(-1)
                
                Button(action: {
                    self.showingImagePicker = true
                }, label: {
                    if day.image != nil {
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
                    } else {
                        VStack(alignment: .leading, content: {
                            Text(String(calendar.component(.day, from: day.date)))
                                .font(.body)
                                .fontWeight(.thin)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .overlay(RoundedRectangle(cornerRadius: 3)
                                            .stroke(Color.gray, lineWidth: 0.5))
                        })
                    }
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .buttonStyle(PlainButtonStyle())
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
        .sheet(isPresented: $showingImagePicker, content: {
            if isAvailable {
                ImagePicker(sourceType: .savedPhotosAlbum, onImagePicked: { (image) in
//                    _ = image.save(in: challenge.imagePath(with: date))
                    guard let index = days.firstIndex(of: day) else {
                        return
                    }
                    
                    days[index] = Day(date: day.date, uiImage: image)
                })
            }
        })
    }
}

struct MCCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MCCalendarView(challenge: ChallengeModel.preview)
    }
}

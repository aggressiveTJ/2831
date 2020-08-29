//
//  Extension.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/09.
//  Copyright © 2020 TJ. All rights reserved.
//

import Foundation
import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

extension Date {
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
    var month: Int {
        Calendar.current.component(.month, from: self)
    }
    var day: Int {
        Calendar.current.component(.day, from: self)
    }
    var monthFirst: Date {
        Calendar.current.dateInterval(of: .month, for: self)?.start ?? self
    }
    
    var headerTitle: String {
        String(format: "%d. %02d", year, month)
    }
    var fileName: String {
        String(format: "%d-%02d-%02d", year, month, day)
    }
    var exifDateString: String {
        let calendar = Calendar.current
        return String(format: "%d. %02d. %02d. %@", year, month, day, calendar.shortWeekdaySymbols[calendar.component(.weekday, from: self) - 1])
    }
    var exifTimeString: String {
        let calendar = Calendar.current
        return String(format: "%02d:%02d:%02d", calendar.component(.hour, from: self), calendar.component(.minute, from: self), calendar.component(.second, from: self))
    }
}

extension Calendar {
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

extension UIImage {
    @discardableResult func save(in path: URL) -> Bool {
        guard let data = jpegData(compressionQuality: 0.8) else {
            print("[ERROR] no data")
            return false
        }
        
        do {
            try data.write(to: path)
        } catch {
            print("[ERROR] \(error.localizedDescription)")
            return false
        }
        
        return true
    }
}

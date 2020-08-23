//
//  Extension.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/09.
//  Copyright © 2020 TJ. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

extension Date {
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
    var month: Int {
        Calendar.current.component(.month, from: self)
    }
    var headerTitle: String {
        "\(year). \(String(format: "%02d", month))"
    }
    var postfix: String {
        "\(year)_\(String(format: "%02d", month))_\(Calendar.current.component(.day, from: self))"
    }
    var monthFirst: Date {
        Calendar.current.dateInterval(of: .month, for: self)?.start ?? self
    }
    
    func isInSameMonth(with another: Date) -> Bool {
        postfix == another.postfix
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
    func save(in path: URL) -> Bool {
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

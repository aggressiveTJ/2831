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
        DateFormatter.exifDateFormatter.string(from: self)
    }
    var exifTimeString: String {
        DateFormatter.exifTimeFormatter.string(from: self)
    }
}

extension DateFormatter {
    static var exifTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss a"
        return formatter
    }
    static var exifDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd.  EEE"
        return formatter
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
    @discardableResult func save(in path: URL, original: Bool = true) -> Bool {
        guard let data = cropAndResize(original: original)?.jpegData(compressionQuality: 1.0) else {
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
    
    private func cropAndResize(original: Bool) -> UIImage? {
        let maxLength: CGFloat = original ? 1000 : 300
        let length = [size.width, size.height, maxLength].min() ?? maxLength
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: length, height: length)))
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = self
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        imageView.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

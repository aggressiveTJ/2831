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
        "\(year). \(month)"
    }
    var postfix: String {
        "\(year)_\(month)_\(Calendar.current.component(.day, from: self))"
    }
    
    func isInSameMonth(with another: Date) -> Bool {
        postfix == another.postfix
    }
}

extension DateFormatter {
    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM"
        return formatter
    }
}

extension UIImage {
    func save(in path: URL) -> Bool {
        guard let data = jpegData(compressionQuality: 0.8) else {
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

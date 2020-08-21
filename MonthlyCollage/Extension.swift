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
        "_\(year)_\(month)"
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
    func save(in path: URL) {
        
    }
}

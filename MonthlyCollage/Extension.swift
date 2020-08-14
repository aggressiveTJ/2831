//
//  Extension.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/09.
//  Copyright © 2020 TJ. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

extension DateFormatter {
    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM"
        return formatter
    }
}

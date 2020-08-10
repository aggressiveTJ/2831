//
//  Extension.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/09.
//  Copyright © 2020 TJ. All rights reserved.
//

import Foundation
import SwiftUI

extension Challenge {
    static var empty: Challenge {
        let context = (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).persistentContainer.viewContext
        return Challenge(context: context)
    }
    
    var isVaild: Bool {
        (id != nil) && (name?.isEmpty == true) && (date != nil)
    }
}

extension DateFormatter {
    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM"
        return formatter
    }
    
    static var longStyle: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
}

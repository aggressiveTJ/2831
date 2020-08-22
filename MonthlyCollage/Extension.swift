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

extension Array where Element == UIImage {
    func collage(itemSize: CGSize, date: Date = Date()) -> UIImage? {
        guard itemSize.width == itemSize.height else {
            print("only supports square size")
            return nil
        }
        
        let margin = itemSize.width * 0.15
        let interItemSpacing = itemSize.width * 0.07
        let numberOfRows = CGFloat(ceilf(Float(count + startIndex) / 7))
        let width = (itemSize.width * 7) + (interItemSpacing * 6) + (margin * 2)
        let height = (itemSize.width * 1.5) + (itemSize.width * numberOfRows) + (interItemSpacing * (numberOfRows - 1)) + (margin * 2) + interItemSpacing
        let canvas = CGRect(x: 0, y: 0, width: width, height: height)
        
        var currentColumn = Calendar.current.component(.weekday, from: date.monthFirst) - 1
        var currentRow = 0
        
        UIGraphicsBeginImageContextWithOptions(canvas.size, false, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        
        // MARK: - draw header view
        let headerView = UIView(frame: CGRect(x: 0, y: margin, width: canvas.width, height: itemSize.width * 1.5))
        
        let headerLabel = UILabel(frame: CGRect(x: 0, y: margin, width: canvas.width, height: itemSize.width))
        headerLabel.font = UIFont.systemFont(ofSize: itemSize.width * 0.6, weight: .ultraLight)
        headerLabel.text = date.headerTitle
        headerLabel.textAlignment = .center
        headerView.addSubview(headerLabel)
        
        let columnHeaderView = UIStackView(frame: CGRect(x: margin, y: margin + itemSize.width + interItemSpacing, width: canvas.width - (margin * 2), height: itemSize.width / 4))
        columnHeaderView.axis = .horizontal
        columnHeaderView.distribution = .fillEqually
        
        for string in Calendar.current.shortWeekdaySymbols.map({ $0.uppercased() }) {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.width / 4))
            label.font = UIFont.systemFont(ofSize: itemSize.width / 6, weight: .semibold)
            label.text = string
            label.textAlignment = .center
            columnHeaderView.addArrangedSubview(label)
        }
        headerView.addSubview(columnHeaderView)
        
        let topLineView = UIView(frame: CGRect(x: margin, y: columnHeaderView.frame.minY - (interItemSpacing / 2), width: canvas.width - (margin * 2), height: 1))
        topLineView.backgroundColor = .darkGray
        headerView.addSubview(topLineView)
        
        let bottomLineView = UIView(frame: CGRect(x: margin, y: columnHeaderView.frame.maxY + (interItemSpacing / 2), width: canvas.width - (margin * 2), height: 1))
        bottomLineView.backgroundColor = .darkGray
        headerView.addSubview(bottomLineView)
        
        if let context = UIGraphicsGetCurrentContext() {
            headerView.layer.render(in: context)
        }
        
        // MARK: - draw image collage
        for image in self {
            let collumn = CGFloat(currentColumn)
            let row = CGFloat(currentRow)
            
            let originX = margin + (itemSize.width * collumn) + (interItemSpacing * collumn)
            let originY = (itemSize.width * 1.5) + margin + interItemSpacing + (itemSize.height * row) + (interItemSpacing * row)
            let rect = CGRect(x: originX, y: originY, width: itemSize.width, height: itemSize.height)
            
            let context = UIGraphicsGetCurrentContext()
            context?.saveGState()
            
            UIBezierPath(roundedRect: rect, cornerRadius: itemSize.width * 0.03).addClip()
            image.draw(in: rect)
            
            context?.restoreGState()
            
            currentColumn += 1
            if currentColumn == 7 {
                currentColumn = 0
                currentRow += 1
            }
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

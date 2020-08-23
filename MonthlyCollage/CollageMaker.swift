//
//  CollageMaker.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/23.
//  Copyright © 2020 TJ. All rights reserved.
//

import Foundation
import UIKit

struct CollageItem {
    let date: Date
    let image: UIImage?
}

enum CollageMaker {
    static func collage(with items: [CollageItem], itemSize: CGSize) -> UIImage? {
        guard !items.isEmpty else {
            print("empty items")
            return nil
        }
        
        guard itemSize.width == itemSize.height else {
            print("only supports square size")
            return nil
        }
        
        let monthFirst = items[0].date.monthFirst
        let margin = itemSize.width * 0.15
        let interItemSpacing = itemSize.width * 0.07
        let startIndex = Calendar.current.component(.weekday, from: monthFirst) - 1
        let numberOfRows = CGFloat(ceilf(Float(items.count + startIndex) / 7))
        let width = (itemSize.width * 7) + (interItemSpacing * 6) + (margin * 2)
        let height = (itemSize.width * 1.5) + (itemSize.width * numberOfRows) + (interItemSpacing * (numberOfRows - 1)) + (margin * 2) + interItemSpacing
        let canvas = CGRect(x: 0, y: 0, width: width, height: height)
        
        var currentColumn = startIndex
        var currentRow = 0
        
        UIGraphicsBeginImageContextWithOptions(canvas.size, false, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        
        // MARK: - draw header view
        let headerView = UIView(frame: CGRect(x: 0, y: margin, width: canvas.width, height: itemSize.width * 1.5))
        
        let headerLabel = UILabel(frame: CGRect(x: 0, y: margin, width: canvas.width, height: itemSize.width))
        headerLabel.font = UIFont.systemFont(ofSize: itemSize.width * 0.6, weight: .ultraLight)
        headerLabel.text = monthFirst.headerTitle
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
        for item in items {
            let collumn = CGFloat(currentColumn)
            let row = CGFloat(currentRow)
            
            let originX = margin + (itemSize.width * collumn) + (interItemSpacing * collumn)
            let originY = (itemSize.width * 1.5) + margin + interItemSpacing + (itemSize.height * row) + (interItemSpacing * row)
            let rect = CGRect(x: originX, y: originY, width: itemSize.width, height: itemSize.height)
            
            if let image = item.image {
                let context = UIGraphicsGetCurrentContext()
                context?.saveGState()
                UIBezierPath(roundedRect: rect, cornerRadius: itemSize.width * 0.03).addClip()
                image.draw(in: rect)
                context?.restoreGState()
            } else {
                let emptyView = UIView(frame: rect)
                emptyView.layer.cornerRadius = itemSize.width * 0.03
                emptyView.layer.borderWidth = 1
                emptyView.layer.borderColor = UIColor.lightGray.cgColor
                emptyView.drawHierarchy(in: rect, afterScreenUpdates: true)
            }
            
            currentColumn += 1
            if currentColumn == 7 {
                currentColumn = 0
                currentRow += 1
            }
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

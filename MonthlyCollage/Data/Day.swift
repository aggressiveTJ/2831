//
//  Day.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/29.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct Day: Equatable, Hashable, Identifiable {
    var id: Date {
        date
    }
    
    let date: Date
    var originalImagePath: String?
    var thumbnailImagePath: String?

    init(date: Date, in challenge: Challenge) {
        self.date = date
        self.originalImagePath = challenge.imagePath(with: date)
        self.thumbnailImagePath = challenge.imagePath(with: date, original: false)
    }
    
    var originalImage: UIImage? {
        image(from: originalImagePath)
    }
    
    var thumbnailImage: UIImage? {
        image(from: thumbnailImagePath)
    }
    
    var hasImages: Bool {
        guard let originalPath = originalImagePath,
              let thumbnailPath = thumbnailImagePath else {
            return false
        }
        
        let fileManager = FileManager()
        return fileManager.fileExists(atPath: originalPath) && fileManager.fileExists(atPath: thumbnailPath)
    }
    
    private func image(from path: String?) -> UIImage? {
        guard let path = path,
              let image = UIImage(contentsOfFile: path) else {
            return nil
        }
        
        return image
    }
    
    @discardableResult func saveImage(with image: UIImage) -> Bool {
        guard let originalPath = originalImagePath,
              let thumbnailPath = thumbnailImagePath else {
            return false
        }
        
        return image.save(in: URL(fileURLWithPath: originalPath)) && image.save(in: URL(fileURLWithPath: thumbnailPath), original: false)
    }
}

extension Day {
    func sharableImage(original: Bool = false) -> UIImage? {
        guard let image = original ? originalImage : thumbnailImage else {
            return nil
        }
        
        let length = min(image.size.width, image.size.height)
        let canvasSize = CGSize(width: length, height: length)
        
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, image.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        
        var origin = CGPoint.zero
        if image.size.width > length {
            origin.x = (length - image.size.width) / 2
        }
        if image.size.height > length {
            origin.y = (length - image.size.height) / 2
        }
        
        let imageRect = CGRect(origin: origin, size: image.size)
        image.draw(in: imageRect)
        
        // MARK: - draw EXIF view
        let date = Date()
        let factor = length * 0.05
        let exifView = UIView(frame: imageRect)

        let gradient = CAGradientLayer()
        gradient.frame = imageRect
        gradient.colors = [
            UIColor.init(white: 0, alpha: 0).cgColor,
            UIColor.init(white: 0, alpha: 0).cgColor,
            UIColor.init(white: 0, alpha: 0.8).cgColor,
        ]
        gradient.locations = [0.0, 0.7, 1.0]
        exifView.layer.addSublayer(gradient)
        
        var y = canvasSize.height - (factor * 1.1)
        let timeLabel = UILabel(frame: CGRect(x: factor, y: y - (factor * 1.2), width: canvasSize.width, height: (factor * 1.2)))
        timeLabel.font = UIFont.systemFont(ofSize: (factor * 1.1), weight: .thin)
        timeLabel.text = date.exifTimeString.lowercased()
        timeLabel.textColor = .init(white: 1, alpha: 0.8)
        setAppearance(timeLabel)
        exifView.addSubview(timeLabel)
        
        y -= (factor * 1.35)
        let dateLabel = UILabel(frame: CGRect(x: factor, y: y - (factor * 1.6), width: canvasSize.width, height: factor * 1.6))
        dateLabel.font = UIFont.systemFont(ofSize: factor * 1.5, weight: .thin)
        dateLabel.text = date.exifDateString
        dateLabel.textColor = .init(white: 1, alpha: 0.9)
        setAppearance(dateLabel)
        exifView.addSubview(dateLabel)
        
        if let context = UIGraphicsGetCurrentContext() {
            exifView.layer.render(in: context)
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func setAppearance(_ label: UILabel) {
        label.textAlignment = .left
        label.numberOfLines = 1
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 4.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.masksToBounds = false
    }
}

extension Array where Element == Day {
    func collage(itemSize: CGSize) -> UIImage? {
        guard !isEmpty else {
            print("empty items")
            return nil
        }
        
        guard itemSize.width == itemSize.height else {
            print("only supports square size")
            return nil
        }
        
        let monthFirst = self[0].date.monthFirst
        let margin = itemSize.width * 0.15
        let interItemSpacing = itemSize.width * 0.07
        let startIndex = Calendar.current.component(.weekday, from: monthFirst) - 1
        let numberOfRows = CGFloat(ceilf(Float(count + startIndex) / 7))
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
        for item in self {
            let collumn = CGFloat(currentColumn)
            let row = CGFloat(currentRow)
            
            let originX = margin + (itemSize.width * collumn) + (interItemSpacing * collumn)
            let originY = (itemSize.width * 1.5) + margin + interItemSpacing + (itemSize.height * row) + (interItemSpacing * row)
            let rect = CGRect(x: originX, y: originY, width: itemSize.width, height: itemSize.height)
            let imageView = UIImageView(frame: rect)
            
            if let image = item.sharableImage() {
                imageView.image = image
                imageView.contentMode = .scaleAspectFill
            } else {
                imageView.layer.borderWidth = 1
                imageView.layer.borderColor = UIColor.lightGray.cgColor
            }
            
            imageView.layer.cornerRadius = itemSize.width * 0.03
            imageView.layer.masksToBounds = true
            imageView.drawHierarchy(in: rect, afterScreenUpdates: true)
            
            currentColumn += 1
            if currentColumn == 7 {
                currentColumn = 0
                currentRow += 1
            }
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

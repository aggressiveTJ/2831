//
//  Day.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/29.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct Day: Equatable, Hashable {
    let date: Date
    var uiImage: UIImage?
    
    init(date: Date, uiImage: UIImage? = nil) {
        self.date = date
        self.uiImage = uiImage
    }
    
    var image: Image? {
        guard let uiImage = uiImage else {
            return nil
        }
        
        return Image(uiImage: uiImage)
            .resizable()
    }
}

extension Day {
    var sharableImage: UIImage? {
        guard let image = uiImage else {
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
        UIBezierPath(roundedRect: CGRect(origin: .zero, size: canvasSize), cornerRadius: length * 0.03).addClip()
        image.draw(in: imageRect)
        
        // MARK: - draw EXIF view
        let date = Date()
        let factor = length * 0.1
        let exifViewRect = CGRect(x: factor, y: factor, width: length - (factor * 2), height: length - (factor * 2))
        let exifView = UIView(frame: exifViewRect)
        
        let timeLabel = UILabel(frame: CGRect(x: 0, y: exifViewRect.height - (factor * 0.3), width: exifViewRect.width, height: factor * 0.3))
        timeLabel.font = UIFont.systemFont(ofSize: factor * 0.2, weight: .ultraLight)
        timeLabel.text = date.exifTimeString
        timeLabel.textAlignment = .left
        timeLabel.numberOfLines = 1
        exifView.addSubview(timeLabel)
        
        let dateLabel = UILabel(frame: CGRect(x: 0, y: canvasSize.height - (factor * 0.3) - (factor * 0.5), width: exifViewRect.width, height: factor * 0.5))
        dateLabel.font = UIFont.systemFont(ofSize: factor * 0.4, weight: .ultraLight)
        dateLabel.text = date.exifDateString
        dateLabel.textAlignment = .left
        dateLabel.numberOfLines = 1
        exifView.addSubview(dateLabel)
        
        if let context = UIGraphicsGetCurrentContext() {
            exifView.layer.render(in: context)
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

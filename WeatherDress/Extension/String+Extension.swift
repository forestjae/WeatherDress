//
//  String+Extension.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/09.
//

import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    func attach(
        with imageName: String,
        pointSize: CGFloat,
        tintColor: UIColor
    ) -> NSAttributedString {
        let imageAttachment = NSTextAttachment()
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: pointSize,
            weight: .regular,
            scale: .default
        )

        imageAttachment.image = UIImage(
            systemName: imageName,
            withConfiguration: imageConfig
        )?.withTintColor(tintColor)
        let fullString = NSMutableAttributedString(string: "")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: " \(self)"))

        return fullString
    }
}

extension String {
    func convertToDate() -> Date? {
        guard let hour = Int(String(self.prefix(2))) else {
            return nil
        }
        if hour > 4 {
            let string = DateFormatter.yearMonthDay.string(from: Date()) + self
            return DateFormatter.yearMonthDayHour.date(from: string)
        } else {
            let string = DateFormatter.yearMonthDay.string(from: Date() + 3600 * 24) + self
            return DateFormatter.yearMonthDayHour.date(from: string)
        }
    }
}

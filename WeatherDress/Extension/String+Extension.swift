//
//  String+Extension.swift
//  WeatherDress
//
//  Created by Lee Seung-Jae on 2022/05/09.
//

import UIKit

extension String {
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

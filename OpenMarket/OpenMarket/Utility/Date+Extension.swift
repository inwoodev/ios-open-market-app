//
//  Date+Extension.swift
//  OpenMarket
//
//  Created by James on 2021/08/30.
//

import Foundation

extension Date {
    static let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = .current
        return dateFormatter
    }()
    
    var formattedString: String {
        return Date.formatter.string(from: self)
    }
}

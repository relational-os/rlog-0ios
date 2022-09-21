//
//  DateExtensions.swift
//  Log (iOS)
//
//  Created by CJ Pais on 7/13/22.
//

import Foundation

extension Date {
    func toTime(format: String = "h:mm a") -> String {
        return getFormat(format: format)
    }
    
    private func getFormat(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

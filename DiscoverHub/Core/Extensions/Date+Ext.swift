//
//  Date+Ext.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-16.
//

import Foundation

extension Date {
    func toReadableFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}

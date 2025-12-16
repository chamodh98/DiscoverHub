//
//  String+Ext.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-17.
//

import Foundation

extension String {
    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

//
//  String+Ext.swift
//  CovidCzech
//
//  Created by Richard Amare on 10/8/21.
//

import SwiftUI

extension String {
    func toDate() -> Date {
        let formattedString = String(self.prefix(19) + self.suffix(1))
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: formattedString) ?? .now.addingTimeInterval(-60)
    }
}

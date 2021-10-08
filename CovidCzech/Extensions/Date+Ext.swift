//
//  Date+Ext.swift
//  CovidCzech
//
//  Created by Richard Amare on 05.05.2021.
//

import Foundation

extension Date: RawRepresentable {
    private static let formatter = ISO8601DateFormatter()
    
    public var rawValue: String {
        Date.formatter.string(from: self)
    }
    
    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
}

extension Date {
    var timeAgo: String {
        self.formatted(.relative(presentation: .named))
    }
}

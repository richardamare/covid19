//
//  Date+Ext.swift
//  CovidCzech
//
//  Created by Richard Amare on 05.05.2021.
//

import Foundation

extension Date {
    var timeAgo: String {
        self.formatted(.relative(presentation: .named))
    }
}

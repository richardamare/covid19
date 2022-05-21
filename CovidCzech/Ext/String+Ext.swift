//
//  String+Ext.swift
//  CovidCzech
//
//  Created by Richard Amare on 5/21/22.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return f.date(from: self)
    }
}

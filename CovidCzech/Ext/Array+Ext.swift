//
//  Array+Ext.swift
//  CovidCzech
//
//  Created by Richard Amare on 10/8/21.
//

import Foundation

extension Array {
    func optionalPrefix(_ maxLength: Int?) -> [Element] {
        if let maxLength = maxLength {
            return self.prefix(maxLength).map { $0 }
        }
        return self
    }
}

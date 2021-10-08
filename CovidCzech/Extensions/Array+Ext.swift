//
//  Array+Ext.swift
//  CovidCzech
//
//  Created by Richard Amare on 10/8/21.
//

import Foundation

extension Array where Element == InfectedDaily {
    func reduced(to mode: ChartPreview) -> [Element] {
        switch mode {
        case .week:
            return self.suffix(7)
        case .month:
            return self.suffix(31)
        case .threeMonths:
            return self.suffix(30 * 3)
        case .sixMonths:
            return self.suffix(30 * 6)
        case .all:
            return self
        }
    }
}

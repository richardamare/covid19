//
//  ChartPreview.swift
//  CovidCzech
//
//  Created by Richard Amare on 10/8/21.
//

import SwiftUI

enum ChartPreview: LocalizedStringKey, CaseIterable {
    case week = "1W"
    case month = "1M"
    case threeMonths = "3M"
    case sixMonths = "6M"
    case all = "All"
    
    var limit: Int? {
        switch self {
        case .week:
            return 7
        case .month:
            return 31
        case .threeMonths:
            return 90
        case .sixMonths:
            return 189
        case .all:
            return nil
        }
    }
}

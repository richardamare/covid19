//
//  Constants.swift
//  CovidCzech
//
//  Created by Richard Amare on 05.05.2021.
//

import SwiftUI

enum GraphRange: String, CaseIterable {
    case week = "1W"
    case month = "1M"
    case threeMonths = "3M"
    case sixMonths = "6M"
    case all = "ALL"
}

let regionNames = ["Hlavní město Praha", "Středočeský kraj", "Jihočeský kraj", "Plzeňský kraj", "Karlovarský kraj", "Ústecký kraj", "Liberecký kraj", "Královéhradecký kraj", "Pardubický kraj", "Kraj Vysočina", "Jihomoravský kraj", "Olomoucký kraj", "Zlínský kraj", "Moravskoslezský kraj"]

/// We use this because of nil safety. When app launches, there is no data before fetching.
let defaultRegion = Region(name: "Hlavní město Praha", infected: 0, recovered: 0, deceased: 0)
let defaultCountry = Country(infected: 0, recovered: 0, hospitalized: 0, critical: 0, deceased: 0, antigen: 0, pcr: 0, totalTested: 0)

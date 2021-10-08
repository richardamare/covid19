//
//  Country.swift
//  CovidCzech
//
//  Created by Richard Amare on 10/8/21.
//

import Foundation

struct Country: Decodable {
    var infected, recovered, hospitalized, critical, deceased, testedAG, testedPCR, totalTested: Int
    var infectedDaily: [InfectedDaily]
    var infectedByRegion: [Region]
    var recoveredByRegion: [Region]
    var deceasedByRegion: [Region]
    var lastUpdatedAtSource: String
    
    static let dummy = Country(infected: 0, recovered: 0, hospitalized: 0, critical: 0, deceased: 0, testedAG: 0, testedPCR: 0, totalTested: 0, infectedDaily: [], infectedByRegion: [], recoveredByRegion: [], deceasedByRegion: [], lastUpdatedAtSource: "2021-10-08T06:41:00.000Z")
}

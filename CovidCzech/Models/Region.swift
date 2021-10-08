//
//  Region.swift
//  CovidCzech
//
//  Created by Richard Amare on 10/8/21.
//

import Foundation

struct Region: Decodable, Hashable {
    var name: String
    var value: Int
    
    static let dummy = Region(name: "Hlavní město Praha", value: 0)
}


//
//  Region.swift
//  CovidCzech
//
//  Created by Richard Amare on 05.05.2021.
//

import Foundation

struct Region: Identifiable {
    var id = UUID()
    var name: String
    var infected: Int
    var recovered: Int
    var deceased: Int
}

//
//  InfectedDaily.swift
//  CovidCzech
//
//  Created by Richard Amare on 10/8/21.
//

import Foundation

struct InfectedDaily: Decodable {
    var value: Int
    var date: String
    
    var formattedDate: Date { date.toDate() ?? .now }
}

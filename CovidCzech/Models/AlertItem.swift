//
//  AlertItem.swift
//  CovidCzech
//
//  Created by Richard Amare on 5/21/22.
//

import SwiftUI

enum AlertItem: Identifiable {
    case ok(title: String, message: String? = nil)
    
    var id: String {
        switch self {
        case .ok:
            return "ok"
        }
    }
    
    var alert: Alert {
        switch self {
        case .ok(title: let title, message: let message):
            return Alert(title: Text(title), message: message == nil ? nil : Text(message!))
        }
    }
}

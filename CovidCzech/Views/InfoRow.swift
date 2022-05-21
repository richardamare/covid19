//
//  InfoRow.swift
//  CovidCzech
//
//  Created by Richard Amare on 10/8/21.
//

import SwiftUI

struct InfoRow: View {
    var label: LocalizedStringKey
    var value: Int
    
    init(_ label: LocalizedStringKey, value: Int?) {
        self.label = label
        self.value = value ?? 0
    }
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.primary)
            Spacer()
            Text("\(value)")
                .foregroundColor(.secondary)
        }
    }
}

struct InfoRow_Previews: PreviewProvider {
    static var previews: some View {
        InfoRow("Infected", value: 200)
    }
}

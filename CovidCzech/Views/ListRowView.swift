//
//  ListRowView.swift
//  CovidCzech
//
//  Created by Richard Amare on 05.05.2021.
//

import SwiftUI

struct ListRowView: View {
    var key: LocalizedStringKey
    var value: Int
    
    var body: some View {
        HStack {
            Text(key)
            Spacer()
            Text("\(value)")
                .fontWeight(.medium)
        }
    }
}

struct ListRowView_Previews: PreviewProvider {
    static var previews: some View {
        ListRowView(key: "Infected", value: 0)
    }
}

//
//  ContentView.swift
//  SwiftUIInteractionChallenge
//
//  Created by Enebin on 11/7/23.
//

import SwiftUI

struct ContentView: View {
    let circlesData = [
        CircleData(
            label: "Expressive",
            coordinate: (x: -0.2209559268150387, y: -0.6597031040497751),
            radius: 0.16753215819093129),
        CircleData(
            label: "Funny",
            coordinate: (x: 0.3864041646343055, y: 0.6054490800846822),
            radius: 0.2817543825249447),
        CircleData(
            label: "Extrovert",
            coordinate: (x: -0.5711411358905634, y: -0.23634056797191685),
            radius: 0.381890736863092),
        CircleData(
            label: "Positive",
            coordinate: (x: -0.26152337336370673, y: 0.46187070430546906),
            radius: 0.381890736863092),
        CircleData(
            label: "Sensitive",
            coordinate: (x: 0.3709271337823364, y: -0.23634056797191685),
            radius: 0.5601775328098079)
    ]
    
    let widthUnit: CGFloat = 400
    
    var body: some View {
        ZStack {
            ForEach(circlesData) { datum in
                Circle()
                    .foregroundStyle(.blue.opacity(0.4))
                    .overlay {
                        Text(datum.label).font(.caption2)
                    }
                    .frame(width: datum.radius * widthUnit)
                    .offset(
                        x: datum.coordinate.x * widthUnit / 2,
                        y: datum.coordinate.y * widthUnit / 2)
            }
        }
    }
}

#Preview {
    ContentView()
}

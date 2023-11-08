//
//  CircleData.swift
//  SwiftUIInteractionChallenge
//
//  Created by Enebin on 11/7/23.
//

import Foundation

struct CircleData: Identifiable {
    let id = UUID()
    let label: String
    let coordinate: (x: CGFloat, y: CGFloat)
    let radius: CGFloat
}

extension CircleData: Equatable {
    static func == (lhs: CircleData, rhs: CircleData) -> Bool {
        lhs.id == rhs.id
    }
}

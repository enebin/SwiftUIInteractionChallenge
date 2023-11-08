//
//  BackgroundBlurringView.swift
//  SwiftUIInteractionChallenge
//
//  Created by Enebin on 11/8/23.
//

import SwiftUI

struct BackgroundBlurringView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    init(style: UIBlurEffect.Style) {
        self.style = style
    }

    func makeUIView(context: UIViewRepresentableContext<BackgroundBlurringView>) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(
        _ uiView: UIVisualEffectView,
        context: UIViewRepresentableContext<BackgroundBlurringView>
    ) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

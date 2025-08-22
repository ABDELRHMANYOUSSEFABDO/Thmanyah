//
//  Haptics.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//

import UIKit

enum Haptics {
    static func tap() {
        let g = UIImpactFeedbackGenerator(style: .light)
        g.prepare()
        g.impactOccurred()
    }

    static func success() {
        let g = UINotificationFeedbackGenerator()
        g.prepare()
        g.notificationOccurred(.success)
    }

    static func error() {
        let g = UINotificationFeedbackGenerator()
        g.prepare()
        g.notificationOccurred(.error)
    }
}

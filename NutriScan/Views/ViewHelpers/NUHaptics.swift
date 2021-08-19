//
//  NUHaptics.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 19/08/2021.
//

import UIKit
import SwiftUI

struct NUHaptics {
    private let generator = UINotificationFeedbackGenerator()
    
    func success() {
        generator.notificationOccurred(.success)
    }
}

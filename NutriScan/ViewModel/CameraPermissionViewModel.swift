//
//  CameraPermissionViewModel.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 25/10/2021.
//

import SwiftUI
import AVFoundation

class CameraPermissionViewModel : ObservableObject {
    @Published var accessGranted = false
    
    private let requestAccess: (AVMediaType, @escaping (Bool) -> Void) -> Void

    init(
        requestAccess: @escaping (AVMediaType, @escaping (Bool) -> Void) -> Void = AVCaptureDevice.requestAccess
    ) {
        self.requestAccess = requestAccess
    }
    
    func requestPermission() {
        requestAccess(.video) { accessGranted in
            DispatchQueue.main.async {
                self.accessGranted = accessGranted
            }
        }
    }
}


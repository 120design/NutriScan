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
    
    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { accessGranted in
            DispatchQueue.main.async {
                self.accessGranted = accessGranted
            }
        })
    }
}


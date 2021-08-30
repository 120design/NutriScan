//
//  NUBackgroundClearView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 30/08/2021.
//

import SwiftUI

struct NUBackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

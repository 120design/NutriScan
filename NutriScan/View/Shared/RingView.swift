//
//  RingView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 04/09/2021.
//

import SwiftUI

struct RingView: View {
    let size: CGFloat
    let percent: CGFloat
    let color: Color
    
    let lineWidth: CGFloat = 12
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    color.opacity(0.4),
                    style: StrokeStyle(
                        lineWidth: lineWidth
                    )
                )
            Circle()
                .trim(
                    from: 1 - percent / 100,
                    to: 1
                )
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .rotationEffect(.degrees(90))
                .rotation3DEffect(
                    .degrees(180),
                    axis: (x:1, y: 0, z: 0.0)
                )
        }
        .frame(width: size, height: size)
    }
}

struct RingView_Previews: PreviewProvider {
    static var previews: some View {
        RingView(size: 100, percent: 60, color: .red)
    }
}

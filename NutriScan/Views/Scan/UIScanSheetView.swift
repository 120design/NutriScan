//
//  UIScanSheetView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 25/12/2020.
//

import SwiftUI

struct UIScanSheetView: View {
    @Binding var torchIsOn: Bool
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 3)
                .foregroundColor(.blue)
                .frame(width: 50, height: 5)
            Button(action: {
                self.torchIsOn.toggle()
            }, label: {
                HStack {
                    ZStack {
                        Circle()
                            .frame(width: 60, height: 60)
                        Image(systemName: "flashlight.on.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                    }
                    Spacer()
                }
            })
            .padding()
        }
        .padding()
    }
}

struct UIScanSheetView_Previews: PreviewProvider {
    static var previews: some View {
        UIScanSheetView(torchIsOn: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}

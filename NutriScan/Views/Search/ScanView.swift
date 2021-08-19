//
//  ScanView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 19/08/2021.
//

import SwiftUI
import CarBode
import AVFoundation

struct ScanView: View {
    @Binding var eanCode: String
    let search: () -> ()
    
    @State var torchIsOn = false
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                CBScanner(
                    supportBarcode: .constant([.ean8, .ean13]),
                    torchLightIsOn: $torchIsOn,
                    scanInterval: .constant(5.0)
                ) {
                    self.eanCode = $0.value
                    self.search()
                }
                onDraw: {
                    //line width
                    let lineWidth: CGFloat = 2
                    
                    //line color
                    let lineColor = UIColor.red
                    
                    //Fill color with opacity
                    //You also can use UIColor.clear if you don't want to draw fill color
                    let fillColor = UIColor(red: 0, green: 1, blue: 0.2, alpha: 0.4)
                    
                    //Draw box
                    $0.draw(lineWidth: lineWidth, lineColor: lineColor, fillColor: fillColor)
                }
                .frame(width: 250, height: 250)
                .mask(RoundedRectangle(cornerRadius: 40, style: .continuous))
                
                Image("ScanOutlines")
                    .resizable()
                    .frame(width: 256, height: 256)
                    .foregroundColor(.nuPrimaryColor)
            }
            
            Spacer()
            
            HStack {
                Button(action: {
                    torchIsOn.toggle()
                    NUHaptics().success()
                }, label: {
                    Image(
                        systemName: torchIsOn
                            ? "flashlight.on.fill"
                            : "flashlight.off.fill"
                    )
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 44, height: 44)
                    .font(.system(size: 30))
                    .foregroundColor(.nuTertiaryColor)
                    .padding()
                    .background(Color.nuQuaternaryColor)
                    .mask(Circle())
                    .shadow(
                        color: torchIsOn
                            ? .nuQuaternaryColor
                            : .clear,
                        radius: 12,
                        x: 0.0,
                        y: 0.0
                    )
                    .padding()
                })
                Spacer()
            }
        }
        .frame(maxHeight: .infinity)
    }
}

struct ScanView_Previews: PreviewProvider {
    static func search () {}
    
    static var previews: some View {
        ScanView(eanCode: .constant(""), search: search)
    }
}

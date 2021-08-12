//
//  ScanSheetView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 25/12/2020.
//

import SwiftUI
import CarBode
import AVFoundation

struct ScanSheetView: View {
    @State var torchIsOn = false
    @Binding var eanCode: String?
    @Binding var isShowing: Bool
    @Binding var goToResult: Bool

    var body: some View {
        ZStack(alignment: .top) {
            // View used by real devices
            CBScanner(
                supportBarcode: .constant([.ean8, .ean13]),
                torchLightIsOn: $torchIsOn,
                scanInterval: .constant(5.0)
            ) {
                print($0.value)
                self.eanCode = $0.value
                self.isShowing = false
                self.goToResult = true
            }
            onDraw: {
//                print("Preview View Size = \($0.cameraPreviewView.bounds)")
//                print("Barcode Corners = \($0.corners)")

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
            .navigationTitle("Scan")
            
            // View used by simulator
//            CBScanner(
//                    supportBarcode: .constant([.qr, .code128]), //Set type of barcode you want to scan
//                    scanInterval: .constant(5.0), //Event will trigger every 5 seconds
//                    mockBarCode: .constant(BarcodeData(value:"Mocking data", type: .qr))
//                ){
//                    //When you click the button on screen mock data will appear here
//                    print("BarCodeType =",$0.type.rawValue, "Value =",$0.value)
//                }
            
            UIScanSheetView(torchIsOn: $torchIsOn)
        }
        .foregroundColor(.blue)
    }
}

struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScanSheetView(eanCode: .constant(""), isShowing: .constant(true), goToResult: .constant(false))
    }
}



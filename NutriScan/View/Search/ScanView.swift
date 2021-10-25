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
    @EnvironmentObject var searchViewModel: SearchViewModel
        
    @StateObject private var cameraPermissionViewModel = CameraPermissionViewModel()
        
    @State var torchIsOn = false
    
    var body: some View {
        
        VStack {
            if cameraPermissionViewModel.accessGranted {
                Spacer()
                ZStack {
                    
                    CBScanner(
                        supportBarcode: .constant([.ean8, .ean13]),
                        torchLightIsOn: $torchIsOn,
                        scanInterval: .constant(5.0)
                    ) {
                        self.searchViewModel.eanCode = $0.value
                        self.searchViewModel.getProduct()
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
                            .foregroundColor(
                                .nuSecondaryColor
                            )
                            .padding()
                            .background(Color.nuPrimaryColor)
                            .mask(Circle())
                            .shadow(
                                color: torchIsOn
                                ? .nuPrimaryColor
                                : .clear,
                                radius: 12,
                                x: 0.0,
                                y: 0.0
                            )
                            .padding()
                    })
                    Spacer()
                }
            } else {
                VStack {
                    Text("Merci d’autoriser NutriScan à utiliser la caméra de votre téléphone pour scanner les codes à barres de vos produits.")
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 8)
                        .font(nuBodyBookTextFont)
                        .foregroundColor(.nuPrimaryColor)
                    
                    Button {
                        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    } label: {
                        Text(
                            "Ouvrir les réglages"
                        )
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 6)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.nuPrimaryColor)
                    .background(Color.nuTertiaryColor)
                    .modifier(NUSmoothCornersModifier(cornerRadius: 12))
                    .modifier(NUButtonLabelModifier())
                    .nuShadowModifier(color: .nuTertiaryColor)
                }
                .padding()
                .frame(width: 250, height: 250)
                .background(Color.nuQuaternaryColor)
                .mask(RoundedRectangle(cornerRadius: 40, style: .continuous))
                .nuShadowModifier(color: .nuQuaternaryColor)
            }
            
        }
        .frame(maxHeight: .infinity)
        .onAppear {
            cameraPermissionViewModel.requestPermission()
        }
    }
}

struct ScanView_Previews: PreviewProvider {
    static func search () {}
    
    static var previews: some View {
        ScanView()
            .environmentObject(SearchViewModel())
    }
}

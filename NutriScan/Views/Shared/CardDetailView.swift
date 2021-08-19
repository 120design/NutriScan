//
//  CardDetailView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 15/08/2021.
//

import SwiftUI
import CarBode
import AVFoundation

struct CardDetailView: View {
    @Binding var showDetail: Bool
    
    @Binding var eanCode: String
    @Binding var goToResult: Bool
    
    @State var appear = false
    
    var namespace: Namespace.ID
    let cardType: CardType
    
    func search() {
        guard eanCode.count == 8 || eanCode.count == 13 else {
            return
        }
        eanCode = eanCode
        goToResult = true
        showDetail = false
    }
    
    var body: some View {
        VStack {
            CardHeaderView(cardType: cardType, namespace: namespace)
                .matchedGeometryEffect(id: "header", in: namespace)
                .padding([.top, .horizontal])
            Group {
                if cardType == .scanButton {
                    ScanView(eanCode: $eanCode, search: search)
                } else if cardType == .eanButton {
                    EANView(eanCode: $eanCode, search: search)
                }
            }
            .opacity(appear ? 1 : 0)
            .onAppear {
                appear = true
            }
            .onDisappear {
                appear = false
            }
            .animation(.spring().delay(1))
        }
        .padding(.vertical)
        .background(
            RoundedRectangle(
                cornerRadius: 0,
                style: .continuous
            )
                .fill(Color.nuTertiaryColor)
                .ignoresSafeArea()
                .matchedGeometryEffect(id: "container", in: namespace)
        )
        .animation(.spring())
        .overlay(
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(
                    maxWidth: 32,
                    maxHeight: pictureWidth,
                    alignment: .top
                )
                .padding(.top)
                .foregroundColor(.nuPrimaryColor)
                .padding([.top,.trailing])
                .opacity(appear ? 1 : 0)
                .onAppear {
                    appear = true
                }
                .onDisappear {
                    appear = false
                }
                .animation(.spring().delay(2))
                .onTapGesture {
                    showDetail = false
                },
            alignment: .topTrailing
        )
    }
}

struct DetailView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        CardDetailView(
            showDetail: .constant(true),
            eanCode: .constant(""),
            goToResult: .constant(false),
            namespace: namespace,
            cardType: .eanButton
        )
    }
}

fileprivate struct ScanView: View {
    @Binding var eanCode: String
    let search: () -> ()
    
    @State var torchIsOn = false
    
    var body: some View {
        Group {
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
        }
        .frame(maxHeight: .infinity)
    }
}

fileprivate struct EANView: View {
    @Binding var eanCode: String
    let search: () -> ()
    
    let firstParagraph: some View = VStack(alignment: .leading) {
        Text("Recherchez un produit après avoir soit renseigné ")
        + Text("un code EAN13 à treize chiffres,")
            .font(NUBodyTextEmphasisFont)
        + Text(" soit renseigné ")
        + Text("pressez le bouton de recherche.")
            .font(NUBodyTextEmphasisFont)
    }
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(NUBodyTextFont)
        .foregroundColor(.nuPrimaryColor)
        .padding([.leading, .trailing])
    
    let secondParagraph: some View = VStack(alignment: .leading) {
        Text("Ce code est généralement inscrit ")
        + Text("sous le code à barres")
            .font(NUBodyTextEmphasisFont)
        + Text(" du produit. Une fois le code tapé, ")
        + Text("un code EAN8 à huit chiffres.")
            .font(NUBodyTextEmphasisFont)
    }
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(NUBodyTextFont)
        .foregroundColor(.nuPrimaryColor)
        .padding([.leading, .trailing])
        .padding(.top, 8)
    
    var body: some View {
        Group {
            VStack {
                TextField("", text: $eanCode)
                    .padding(14)
                    .font(.system(size: 16))
                    .foregroundColor(.nuTertiaryColor)
                    .accentColor(.nuTertiaryColor)
                    .modifier(
                        NUPlaceholderStyleModifier(
                            showPlaceHolder: eanCode.isEmpty,
                            placeholder: "Exemple : 8712100325953",
                            foregroundColor: .nuTertiaryColor
                        )
                    )
                    .keyboardType(.numberPad)
                    .overlay(
                        RoundedRectangle(
                            cornerRadius: 12,
                            style: .continuous
                        )
                        .stroke(Color.nuTertiaryColor, lineWidth: 1)
                    )
                    .background(
                        Color.nuTertiaryColor.opacity(0.2)
                            .mask(
                                RoundedRectangle(
                                    cornerRadius: 12,
                                    style: .continuous
                                )
                            )
                    )
                    .animation(nil)
                HStack {
                    Button(action: {
                        eanCode = ""
                    }, label: {
                        Text("Effacer")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 6)
                            .frame(maxWidth: .infinity)
                            .background(Color.nuTertiaryColor)
                            .modifier(NUSmoothCornersModifier(cornerRadius: 12))
                    })
                    .disabled(eanCode.isEmpty)
                    
                    Button(action: {
                        search()
                    }, label: {
                        Text("Rechercher")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 6)
                            .frame(maxWidth: .infinity)
                            .background(Color.nuSecondaryColor)
                            .modifier(NUSmoothCornersModifier(cornerRadius: 12))
                    })
                    .disabled(eanCode.isEmpty)
                }
                .modifier(NUButtonLabelModifier())
            }
            .padding()
            .background(
                Color
                    .nuPrimaryColor
                    .modifier(NUSmoothCornersModifier(cornerRadius: 28))
                    .modifier(NUPrimaryShadowModifier())
            )
            .padding()
            
            firstParagraph
            secondParagraph
            
            Spacer()
        }
    }
}

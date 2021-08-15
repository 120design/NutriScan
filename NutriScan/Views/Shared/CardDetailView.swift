//
//  CardDetailView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 15/08/2021.
//

import SwiftUI

struct CardDetailView: View {
    @Binding var showDetail: Bool
    
    @State var eanValue = ""
    @State var appear = false
    
    let namespace: Namespace.ID
    
    let type: CardView.CardType
    
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
        VStack {
            HStack(spacing: 12.0) {
                Image(
                    systemName: type == .scanButton
                        ? "barcode.viewfinder"
                        : "textformat.123"
                )
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
                .frame(width: pictureWidth, height: pictureWidth)
                .foregroundColor(.nuTertiaryColor)
                .background(Color.nuPrimaryColor)
                .modifier(NUSmoothCornersModifier())
                
                VStack {
                    Text(type.rawValue)
                        .modifier(NUButtonLabelModifier())
                }
                Spacer()
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 32, maxHeight: pictureWidth, alignment: .top)
                    .foregroundColor(.nuPrimaryColor)
                    .onTapGesture {
                        showDetail = false
                    }
            }
            .padding(.top)
            .matchedGeometryEffect(id: "header", in: namespace)
            .padding([.top, .leading, .trailing])
            .frame(maxWidth: .infinity)
            
            ScrollView {
                VStack {
                    TextField("Ex. : 8712100325953", text: $eanValue)
                        .padding(8)
                        .font(NUBodyTextFont)
                        .foregroundColor(.nuTertiaryColor)
                        .keyboardType(.numberPad)
                        .overlay(
                            RoundedRectangle(
                                cornerRadius: 12,
                                style: .continuous
                            )
                            .stroke(Color.nuTertiaryColor, lineWidth: 1)
                        )
                    HStack {
                        Button("Effacer") {
                            eanValue = ""
                        }
                        .padding(6)
                        .frame(maxWidth: .infinity)
                        .background(Color.nuTertiaryColor)
                        .modifier(NUSmoothCornersModifier(cornerRadius: 12))
                        
                        Button("Rechercher") {
                            eanValue = ""
                        }
                        .padding(6)
                        .frame(maxWidth: .infinity)
                        .background(Color.nuSecondaryColor)
                        .modifier(NUSmoothCornersModifier(cornerRadius: 12))
                    }
                    .modifier(NUButtonLabelModifier())
                }
                .padding()
                .background(
                    Color
                        .nuPrimaryColor
                        .modifier(NUSmoothCornersModifier(cornerRadius: 28))
                )
                .modifier(NUPrimaryShadowModifier())
                .padding([.leading, .bottom, .trailing])
                
                firstParagraph
                secondParagraph
            }
            .opacity(appear ? 1 : 0)
//            .offset(y: appear ? 0 : screen.height)
            .onAppear {
                appear = true
            }
            .onDisappear {
                appear = false
            }
            .animation(.spring().delay(0.5))
            .padding(.top)
        }
        .background(
            Color
                .nuTertiaryColor
                .matchedGeometryEffect(id: "container", in: namespace)
                .mask(
                    RoundedRectangle(
                        cornerRadius: 0,
                        style: .continuous
                    )
                    .matchedGeometryEffect(id: "shape", in: namespace)
                )
                .ignoresSafeArea()
        )
        .animation(.spring())
    }
}

struct DetailView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        CardDetailView(
            showDetail: .constant(true),
            namespace: namespace,
            type: .eanButton
        )
    }
}

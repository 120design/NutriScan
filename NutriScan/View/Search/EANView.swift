//
//  EANView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 19/08/2021.
//

import SwiftUI

struct EANView: View {
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    let firstParagraph: some View = VStack(alignment: .leading) {
        Text("Recherchez un produit après avoir soit renseigné ")
            + Text("un code EAN13 à treize chiffres,")
            .font(nuBodyBoldItalicFont)
            + Text(" soit renseigné ")
            + Text("un code EAN8 à huit chiffres.")
            .font(nuBodyBoldItalicFont)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .font(nuBodyBookTextFont)
    .foregroundColor(.nuPrimaryColor)
    .padding([.leading, .trailing])
    
    let secondParagraph: some View = VStack(alignment: .leading) {
        Text("Ce code est généralement inscrit ")
            + Text("sous le code à barres")
            .font(nuBodyBoldItalicFont)
            + Text(" du produit. Une fois le code tapé, ")
            + Text("pressez le bouton de recherche.")
           .font(nuBodyBoldItalicFont)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .font(nuBodyBookTextFont)
    .foregroundColor(.nuPrimaryColor)
    .padding([.leading, .trailing])
    .padding(.top, 8)
    
    var body: some View {
        VStack {
            TextField("", text: $searchViewModel.eanCode)
                .padding(14)
                .font(.system(size: 16))
                .foregroundColor(.nuTertiaryColor)
                .accentColor(.nuTertiaryColor)
                .modifier(
                    NUPlaceholderStyleModifier(
                        showPlaceHolder: searchViewModel.eanCode.isEmpty,
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
                .padding(.bottom, 5)
//                .animation(nil)
            HStack {
                Button(action: {
                    searchViewModel.eanCode = ""
                }, label: {
                    Text("Effacer")
                        .padding(.vertical, 10)
                        .padding(.horizontal, 6)
                        .frame(maxWidth: .infinity)
                        .background(Color.nuTertiaryColor)
                        .modifier(NUSmoothCornersModifier(cornerRadius: 12))
                })
                .disabled(searchViewModel.eanCode.isEmpty)
                
                Button(action: {
                    searchViewModel.getProduct()
                }, label: {
                    Text("Rechercher")
                        .padding(.vertical, 10)
                        .padding(.horizontal, 6)
                        .frame(maxWidth: .infinity)
                        .background(Color.nuSecondaryColor)
                        .modifier(NUSmoothCornersModifier(cornerRadius: 12))
                })
                .disabled(searchViewModel.eanCode.isEmpty)
            }
            .modifier(NUButtonLabelModifier())
        }
        .padding()
        .background(
            Color
                .nuPrimaryColor
                .modifier(NUSmoothCornersModifier(cornerRadius: 28))
        )
        .padding()
        
        firstParagraph
        secondParagraph
        
        Spacer()
    }
}

struct EANView_Previews: PreviewProvider {    
    static var previews: some View {
        EANView()
            .environmentObject(SearchViewModel())
    }
}

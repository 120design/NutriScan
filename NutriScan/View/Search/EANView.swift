//
//  EANView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 19/08/2021.
//

import SwiftUI

struct EANView: View {
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack {
            TextField("", text: $searchViewModel.eanCode)
                .padding(14)
                .font(.system(size: 16))
                .foregroundColor(.nuSecondaryColor)
                .accentColor(.nuSecondaryColor)
                .modifier(
                    NUPlaceholderStyleModifier(
                        showPlaceHolder: searchViewModel.eanCode.isEmpty,
                        placeholder: "Exemple : 8712100325953",
                        foregroundColor: .nuSecondaryColor
                    )
                )
                .keyboardType(.numberPad)
                .focused($isTextFieldFocused)
                .overlay(
                    RoundedRectangle(
                        cornerRadius: 12,
                        style: .continuous
                    )
                    .stroke(Color.nuSecondaryColor, lineWidth: 1)
                )
                .background(
                    Color.nuSecondaryColor.opacity(0.2)
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
                        .background(Color.nuSecondaryColor)
                        .modifier(NUSmoothCornersModifier(cornerRadius: 12))
                })
                .disabled(searchViewModel.clearButtonIsDisabled)
                .opacity(searchViewModel.clearButtonIsDisabled ? 0.6 : 1)
                
                Button(action: {
                    searchViewModel.getProduct()
                }, label: {
                    Text("Rechercher")
                        .padding(.vertical, 10)
                        .padding(.horizontal, 6)
                        .frame(maxWidth: .infinity)
                        .background(Color.nuTertiaryColor)
                        .modifier(NUSmoothCornersModifier(cornerRadius: 12))
                })
                .disabled(searchViewModel.eanCode.isEmpty)
                .opacity(searchViewModel.searchButtonIsDisabled ? 0.6 : 1)
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
        
        if !isTextFieldFocused {
            VStack(alignment: .leading) {
                Text("Recherchez un produit après avoir soit renseigné *un code EAN13 à treize chiffres,* soit renseigné *un code EAN8 à huit chiffres.*")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(nuBodyBookTextFont)
            .foregroundColor(.nuPrimaryColor)
            .padding([.leading, .trailing])
            .padding(.bottom, 8)
            
            VStack(alignment: .leading) {
                Text("Ce code est généralement inscrit *sous le code à barres* du produit. Une fois le code tapé, *pressez le bouton de recherche.*")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(nuBodyBookTextFont)
            .foregroundColor(.nuPrimaryColor)
            .padding([.leading, .trailing])
            .padding(.bottom, 8)
        }

        Spacer()
    }
}

struct EANView_Previews: PreviewProvider {    
    static var previews: some View {
        EANView()
            .environmentObject(SearchViewModel())
    }
}

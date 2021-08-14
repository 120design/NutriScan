//
//  SearchView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 25/12/2020.
//

import SwiftUI

struct SearchView: View {
    @State private var scanViewIsShowing = false
    @State private var eanCode: String?
    @State private var goToResult = false
    
    var text1: some View {
        Text("Rercherchez un produit ")
            .modifier(NUTextBodyModifier())
    }
    
    let firstParagraph: some View =
        HStack {
            Text("Rercherchez un produit ")
                + Text("en scannant son code à barres")
                .font(NUBodyTextEmphasisFont)
                + Text(" ou ")
                + Text("en tapant le numéro EAN")
                .font(NUBodyTextEmphasisFont)
                + Text(" à huit ou treize chiffres inscrit sous son code à barres.")
        }
        .modifier(NUTextBodyModifier())
        .padding([.top, .leading, .trailing])

    let secondaryParagraph: some View =
        HStack {
            Text("NutriScan interrogera alors ")
            + Text("la base de données d’Open Food Facts,")
                .font(
                    .custom(
                        "OperatorMono-MediumItalic",
                        size: 16
                    )
                )
            + Text(" un projet citoyen à but non lucratif créé par des milliers de volontaires à travers le monde recensant ")
            + Text("plus de 700\u{00a0}000 produits.")
                .font(
                    .custom(
                        "OperatorMono-MediumItalic",
                        size: 16
                    )
                )
        }
        .modifier(NUTextBodyModifier())
        .padding([.top, .leading, .trailing])
    
    var body: some View {
        NavigationView {
            ZStack {
                NUwBackgroundView()
                ScrollView {
                    firstParagraph
                    secondaryParagraph
                    
                    Spacer()
                    
                    if let eanCode = eanCode {
                        Text("Code EAN : \(eanCode)")
                    }
                    Button(action: {
                        self.scanViewIsShowing = true
                    }, label: {
                        NUCardView(type: .scanButton)
                    })
                    Text("ou")
                        .padding(.top, -10.0)
                        .padding(.bottom, -5.0)
                        .modifier(NUStrongLabelModifier())
                    NavigationLink(
                        destination:
                            ScrollView{
                                text
                                NavigationLink(
                                    destination:
                                        ScrollView{
                                            text
                                            
                                        }
                                        .navigationTitle("Détails"),
                                    label: {
                                        NUCardView(type: .eanButton)
                                    }
                                )
                            }
                            .navigationTitle("Résultat"),
                        label: {
                            NUCardView(type: .eanButton)
                        }
                    )
                    NavigationLink(
                        destination: SearchResultView(eanCode: eanCode),
                        isActive: $goToResult,
                        label: {
                            EmptyView()
                        }
                    )
                }
            }
            .navigationTitle("Recherche")
            .foregroundColor(.nuSecondaryColor)
            .sheet(isPresented: $scanViewIsShowing, content: {
                ScanSheetView(
                    eanCode: $eanCode,
                    isShowing: $scanViewIsShowing,
                    goToResult: $goToResult
                )
            })
        }
        .nuNavigationBar()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .previewDevice("iPhone 8")
        SearchView()
            .previewDevice("iPhone SE (1st generation)")
    }
}

var text: some View {
    Text("Lol")
}


struct NUwBackgroundView: View {
    var body: some View {
        LinearGradient(
            gradient:
                Gradient(
                    colors: [.nuQuinaryColor, .nuPrimaryColor]
                ),
            startPoint: UnitPoint(x: 0.5, y: 0.55),
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

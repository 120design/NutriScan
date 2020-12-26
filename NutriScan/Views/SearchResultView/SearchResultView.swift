//
//  SearchResultView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 25/12/2020.
//

import SwiftUI

struct SearchResultView: View {
    let eanCode: String?
    var body: some View {
        NavigationView {
            if let eanCode = eanCode {
                Text(eanCode)
                    .navigationTitle("Résultat")
            } else {
                Text("lol")
            }
        }
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView(eanCode: "lol")
    }
}

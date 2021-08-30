//
//  NUTabView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 22/08/2021.
//

import SwiftUI
import Combine

struct NUTabView: View {
    @Namespace private var scanNamespace
    
//    @State private var goToResult = false
//    @State private var eanCode = "3229820108605"
//    @State private var showDetail = false

    
    var body: some View {
        TabView {
            SearchView()
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }
        }
    }
}

struct NUTabView_Previews: PreviewProvider {
    static var previews: some View {
        NUTabView()
    }
}

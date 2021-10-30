//
//  NUTabView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 22/08/2021.
//

import SwiftUI

let nuProVersion = true

struct NUTabView: View {
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    @StateObject private var inAppPurchasesViewModel = InAppPurchasesViewModel()
        
    var body: some View {
        TabView {
            SearchView()
                .tabItem {
                    Label("Recherche", systemImage: "magnifyingglass")
                }
            HistoryView()
                .tabItem {
                    Label("Historique", systemImage: "gobackward")
                }
            FavoritesView()
                .tabItem {
                    Label("Favoris", systemImage: "bookmark")
                }
        }
        .accentColor(.nuTertiaryColor)
        .environmentObject(favoritesViewModel)
        .environmentObject(inAppPurchasesViewModel)
        .onAppear() {
            let shadowImage = UIImage.gradientImageWithBounds(
                bounds: CGRect( x: 0, y: 0, width: UIScreen.main.scale, height: 4),
                colors: [
                    UIColor(Color.nuQuaternaryColor).withAlphaComponent(0).cgColor,
                    UIColor(Color.nuQuaternaryColor).withAlphaComponent(0.4).cgColor
                ]
            )

            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.shadowImage = shadowImage
            
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(Color.nuSecondaryColor)]
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.nuSecondaryColor)

            UITabBar.appearance().standardAppearance = appearance
            
//            UITabBar.appearance().unselectedItemTintColor = UIColor(Color.nuSecondaryColor)
            UITabBar.appearance().backgroundColor = UIColor(Color.nuQuaternaryColor)
            UITabBar.appearance().barTintColor = UIColor(Color.nuQuaternaryColor)
        }
        .onReceive(inAppPurchasesViewModel.$paidVersionIsPurchased) { paidVersionIsPurchased in
            guard let paidVersionIsPurchased = paidVersionIsPurchased
            else {
                favoritesViewModel.favoritesAreGranted = false
                return
            }
            
            favoritesViewModel.favoritesAreGranted = paidVersionIsPurchased
        }
    }
}

struct NUTabView_Previews: PreviewProvider {
    static var previews: some View {
        NUTabView()
    }
}

extension UIImage {
    static func gradientImageWithBounds(bounds: CGRect, colors: [CGColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

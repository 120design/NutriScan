//
//  NUTabView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 22/08/2021.
//

import SwiftUI

let nuProVersion = true

struct NUTabView: View {
    @State var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SearchView()
                .tabItem {
                    Label("Recherche", systemImage: "magnifyingglass")
                }
                .tag(1)
            HistoryView(isSelected: selectedTab == 2)
                .tabItem {
                    Label("Historique", systemImage: "gobackward")
                }
                .tag(2)
            FavoritesView()
                .tabItem {
                    Label("Favoris", systemImage: "bookmark")
                }
                .tag(1)
            SettingsView()
                .tabItem {
                    Label("Réglages", systemImage: "gear")
                }
                .tag(1)
        }
        .accentColor(.nuTertiaryColor)
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

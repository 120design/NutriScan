//
//  NUNavigationBar.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 11/08/2021.
//

import SwiftUI

//struct NUNavigationBar {
//    static func configure() {
//        let navigationBarAppearance = UINavigationBarAppearance()
//        let backButtonAppearance = UIBarButtonItemAppearance()
//
//        let largeTitleShadow = NSShadow()
//        largeTitleShadow.shadowBlurRadius = 6
//        largeTitleShadow.shadowColor = UIColor(.nuQuaternaryColor.opacity(0.8))
//
//        let smallTitleShadow = NSShadow()
//        smallTitleShadow.shadowBlurRadius = 6
//        smallTitleShadow.shadowColor = UIColor(.nuSecondaryColor.opacity(0.8))
//
//        backButtonAppearance.normal.titleTextAttributes = [
//            .foregroundColor: UIColor(.nuSecondaryColor),
//            .font: UIFont(name: "OperatorMono-Light", size: 17)!,
//            .shadow: smallTitleShadow
//        ]
//
//        navigationBarAppearance.configureWithTransparentBackground()
//        navigationBarAppearance.backgroundColor = .clear
//        navigationBarAppearance.largeTitleTextAttributes = [
//            .foregroundColor: UIColor(.nuQuaternaryColor),
//            .font: UIFont(name: "OperatorMono-BoldItalic", size: 34)!,
//            .shadow: largeTitleShadow
//        ]
//
//        navigationBarAppearance.backButtonAppearance = backButtonAppearance
//
//        navigationBarAppearance.c
//
//        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
//        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
//        UINavigationBar.appearance().tintColor = UIColor(.nuSecondaryColor)
//
//    }
//}

struct NUNavigationBar: ViewModifier {

  init() {
    let navigationBarAppearance = UINavigationBarAppearance()
    let backButtonAppearance = UIBarButtonItemAppearance()
    
    let titleShadow = NSShadow()
    titleShadow.shadowBlurRadius = 6
    titleShadow.shadowColor = UIColor(.nuQuaternaryColor.opacity(0.8))

    let backButtonShadow = NSShadow()
    backButtonShadow.shadowBlurRadius = 6
    backButtonShadow.shadowColor = UIColor(.nuSecondaryColor.opacity(0.8))
    
    backButtonAppearance.normal.titleTextAttributes = [
        .foregroundColor: UIColor(.nuSecondaryColor),
        .font: UIFont(name: "OperatorMono-Light", size: 17)!,
        .shadow: backButtonShadow
    ]
    navigationBarAppearance.backButtonAppearance = backButtonAppearance
    
    
    navigationBarAppearance.configureWithDefaultBackground()
    
//    navigationBarAppearance.configureWithTransparentBackground()
//    navigationBarAppearance.backgroundColor = .clear
    
    navigationBarAppearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterialDark)

    navigationBarAppearance.largeTitleTextAttributes = [
        .foregroundColor: UIColor(.nuQuaternaryColor),
        .font: UIFont(name: "OperatorMono-BoldItalic", size: 34)!,
        .shadow: titleShadow
    ]
    
    navigationBarAppearance.titleTextAttributes = [
        .foregroundColor: UIColor(.nuQuaternaryColor),
        .font: UIFont(name: "OperatorMono-BoldItalic", size: 17)!,
        .shadow: titleShadow
    ]
    
    UINavigationBar.appearance().standardAppearance = navigationBarAppearance
    UINavigationBar.appearance().compactAppearance = navigationBarAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    UINavigationBar.appearance().tintColor = UIColor(.nuSecondaryColor)
  }

  func body(content: Content) -> some View {
    content
  }
}
extension View {
  func nuNavigationBar() -> some View {
    self.modifier(NUNavigationBar())
  }
}

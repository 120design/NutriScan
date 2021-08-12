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
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient:
                        Gradient(
                            colors: [.nuQuinaryColor, .nuPrimaryColor]
                        ),
                    //                    Gradient(
                    //                        stops: [
                    //                            .init(color: .nuQuinaryColor, location: 0.5),
                    //                            .init(color: .nuPrimaryColor, location: 0.75)
                    //                        ]
                    //                    ),
                    startPoint: UnitPoint(x: 0.5, y: 0.55),
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                ScrollView {
                    
                    Text("Rercherchez un produit en scannant son code à barres ou en tapant le numéro EAN à huit ou treize chiffres inscrit sous son code à barres.")
                        .padding([.top, .leading, .trailing])
                        .modifier(TextBodyModifier())
                    Text("NutriScan interrogera alors la base de données d’Open Food Facts, un projet citoyen à but non lucratif créé par des milliers de volontaires à travers le monde recensant plus de 700 000 produits à travers le monde.")
                        .modifier(TextBodyModifier())
                        .padding([.top, .leading, .trailing])
                    
                    Spacer()
                    
                    if let eanCode = eanCode {
                        Text("Code EAN : \(eanCode)")
                    }
                    Button(action: {
                        self.scanViewIsShowing = true
                    }, label: {
                        Text("Scanner un code à barres")
                    })
                    Text("ou")
                    NavigationLink(
                        destination:
                            ScrollView{
                                longText
                                NavigationLink(
                                    destination:
                                        ScrollView{
                                            longText
                                            
                                        }
                                        .navigationTitle("Détails"),
                                    label: {
                                        Text("Taper un code EAN13")
                                    }
                                )
                            }
                            .navigationTitle("Résultat"),
                        label: {
                            Text("Taper un code EAN13")
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
    }
}

var longText: some View {
    Text("""
            
            Normally, both your asses would be dead as fucking fried chicken, but you happen to pull this shit while I'm in a transitional period so I don't wanna kill you, I wanna help you. But I can't give you this case, it don't belong to me. Besides, I've already been through too much shit this morning over this case to hand it over to your dumb ass.

            Your bones don't break, mine do. That's clear. Your cells react to bacteria and viruses differently than mine. You don't get sick, I do. That's also clear. But for some reason, you and I react the exact same way to water. We swallow it too fast, we choke. We get some in our lungs, we drown. However unreal it may seem, we are connected, you and I. We're on the same curve, just on opposite ends.

            Do you see any Teletubbies in here? Do you see a slender plastic tag clipped to my shirt with my name printed on it? Do you see a little Asian child with a blank expression on his face sitting outside on a mechanical helicopter that shakes when you put quarters in it? No? Well, that's what you see at a toy store. And you must think you're in a toy store, because you're here shopping for an infant named Jeb.

            Now that there is the Tec-9, a crappy spray gun from South Miami. This gun is advertised as the most popular gun in American crime. Do you believe that shit? It actually says that in the little book that comes with it: the most popular gun in American crime. Like they're actually proud of that shit.

            Look, just because I don't be givin' no man a foot massage don't make it right for Marsellus to throw Antwone into a glass motherfuckin' house, fuckin' up the way the nigger talks. Motherfucker do that shit to me, he better paralyze my ass, 'cause I'll kill the motherfucker, know what I'm sayin'?

            Look, just because I don't be givin' no man a foot massage don't make it right for Marsellus to throw Antwone into a glass motherfuckin' house, fuckin' up the way the nigger talks. Motherfucker do that shit to me, he better paralyze my ass, 'cause I'll kill the motherfucker, know what I'm sayin'?

            My money's in that office, right? If she start giving me some bullshit about it ain't there, and we got to go someplace else and get it, I'm gonna shoot you in the head then and there. Then I'm gonna shoot that bitch in the kneecaps, find out where my goddamn money is. She gonna tell me too. Hey, look at me when I'm talking to you, motherfucker. You listen: we go in there, and that nigga Winston or anybody else is in there, you the first motherfucker to get shot. You understand?

            Now that we know who you are, I know who I am. I'm not a mistake! It all makes sense! In a comic, you know how you can tell who the arch-villain's going to be? He's the exact opposite of the hero. And most times they're friends, like you and me! I should've known way back when... You know why, David? Because of the kids. They called me Mr Glass.

            Now that there is the Tec-9, a crappy spray gun from South Miami. This gun is advertised as the most popular gun in American crime. Do you believe that shit? It actually says that in the little book that comes with it: the most popular gun in American crime. Like they're actually proud of that shit.

            Do you see any Teletubbies in here? Do you see a slender plastic tag clipped to my shirt with my name printed on it? Do you see a little Asian child with a blank expression on his face sitting outside on a mechanical helicopter that shakes when you put quarters in it? No? Well, that's what you see at a toy store. And you must think you're in a toy store, because you're here shopping for an infant named Jeb.
""")
}

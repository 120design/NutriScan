//
//  CardDetailView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 15/08/2021.
//

import SwiftUI

struct CardDetailView: View {
    @EnvironmentObject var cardDetailManager : CardDetailManager
    @EnvironmentObject var searchManager: SearchManager
    
    let namespace: Namespace.ID
    
    @State var appear = false
    
    @State var yTranslation = CGSize.zero.height
    
    let cardType: CardView.CardType
    
    @ViewBuilder
    private var cardContentView: some View {
        switch cardType {
        case .scanButton:
            //            ScanView()
            Text("CardDetailView.scanbutton")
        case .eanButton:
            EANView(
                eanCode: $searchManager.eanCode,
                search: search
            )
        case .product(let product):
            ProductView(product: product)
        }
    }
    
    private func getBackgroundCornerRadius() -> CGFloat {
        if appear {
            return yTranslation < 56
                ? yTranslation / 2
                : 28
        }
        return 28
    }
    
    private func search() {
        searchManager
            .getProduct(from: searchManager.eanCode)
    }
    
    var body: some View {
        VStack {
            CardHeaderView(cardType: cardType)
                .matchedGeometryEffect(id: "header", in: namespace)
                .padding([.top, .horizontal])
            if searchManager.currentlyResearching {
                Spacer()
                ProgressView("Recherche en cours")
                    .progressViewStyle(
                        CircularProgressViewStyle(tint: .nuPrimaryColor)
                    )
                    .foregroundColor(.nuPrimaryColor)
                Spacer()
            } else {
                cardContentView
                    .opacity(appear ? 1 : 0)
                    .animation(.spring())
            }
        }
        .padding(.vertical)
        .animation(.spring())
        .background(
            RoundedRectangle(
                cornerRadius: getBackgroundCornerRadius(),
                style: .continuous
            )
            .fill(cardType.backgroundColor)
            .matchedGeometryEffect(id: "container", in: namespace)
            .ignoresSafeArea()
            .animation(.spring())
        )
        .overlay(
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(
                    maxWidth: 32,
                    maxHeight: pictureWidth,
                    alignment: .top
                )
                .padding(.top)
                .foregroundColor(.nuPrimaryColor)
                .padding([.top,.trailing])
                .opacity(appear ? 1 : 0)
                .animation(.spring())
                .onTapGesture {
                    cardDetailManager.cardDetailView = nil
                },
            alignment: .topTrailing
        )
        .scaleEffect(1 - self.yTranslation / 3000)
        .offset(x: 0, y: yTranslation)
        .gesture(
            DragGesture()
                .onChanged { value in
                    guard appear
                            && value.translation.height > 0
                    else { return }
                    self.yTranslation = value.translation.height
                }
                .onEnded { value in
                    if self.yTranslation > 50 {
                        cardDetailManager.cardDetailView = nil
                        return
                    }
                    self.yTranslation = CGSize.zero.height
                }
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                appear = true
            }
        }
        .onDisappear {
            appear = false
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        CardDetailView(
            namespace: namespace,
            cardType: .eanButton
        )
    }
}



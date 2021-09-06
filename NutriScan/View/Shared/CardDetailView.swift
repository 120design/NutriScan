//
//  CardDetailView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 15/08/2021.
//

import SwiftUI

struct CardDetailView: View {
    @EnvironmentObject var searchManager: SearchManager
    
    @Binding var showDetail: Bool
    @State private var appear = false
    @State private var yTranslation = CGSize.zero.height
    
    let cardType: CardView.CardType
    
    @ViewBuilder
    private var cardContentView: some View {
        switch cardType {
        case .scanButton:
            ScanView()
        case .eanButton:
            EANView()
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
    
    var body: some View {
        VStack {
            CardHeaderView(cardType: cardType)
                .padding(.horizontal)
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
            }
        }
        .padding(.top)
        .background(
            RoundedRectangle(
                cornerRadius: getBackgroundCornerRadius(),
                style: .continuous
            )
            .fill(cardType.backgroundColor)
            .ignoresSafeArea()
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
                .foregroundColor(.nuPrimaryColor)
                .padding([.top,.trailing])
                .opacity(
                    withAnimation(.spring(), {
                        appear ? 1 : 0
                    })
                )
                .onTapGesture {
                    showDetail = false
                },
            alignment: .topTrailing
        )
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
                        showDetail = false
                        return
                    }
                    self.yTranslation = CGSize.zero.height
                }
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                appear = true
            }
        }
        .onDisappear {
            appear = false
        }
    }
}

struct DetailView_Previews: PreviewProvider {    
    static var previews: some View {
        CardDetailView(
            showDetail: .constant(true), cardType: .eanButton
        )
        .environmentObject(SearchManager())
    }
}



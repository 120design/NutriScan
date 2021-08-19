//
//  CardDetailView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 15/08/2021.
//

import SwiftUI

struct CardDetailView: View {
    @Binding var showDetail: Bool
    
    @Binding var eanCode: String
    @Binding var goToResult: Bool
    
    @State var appear = false
    
    @State var yTranslation = CGSize.zero.height
    
    var namespace: Namespace.ID
    let cardType: CardType
    
    func search() {
        guard eanCode.count == 8 || eanCode.count == 13 else {
            return
        }
        eanCode = eanCode
        goToResult = true
        showDetail = false
    }
    
    var body: some View {
        VStack {
            CardHeaderView(cardType: cardType, namespace: namespace)
                .matchedGeometryEffect(id: "header", in: namespace)
                .padding([.top, .horizontal])
            VStack {
                if cardType == .scanButton {
                    ScanView(eanCode: $eanCode, search: search)
                } else if cardType == .eanButton {
                    EANView(eanCode: $eanCode, search: search)
                }
            }
            .opacity(appear ? 1 : 0)
            .animation(.spring())
        }
        .animation(.spring())
        .padding(.vertical)
        .background(
            RoundedRectangle(
                cornerRadius: yTranslation < 56
                    ? yTranslation / 2
                    : 28,
                style: .continuous
            )
            .fill(Color.nuTertiaryColor)
            .ignoresSafeArea()
            .matchedGeometryEffect(id: "container", in: namespace)
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
                    showDetail = false
                },
            alignment: .topTrailing
        )
        .scaleEffect(1 - self.yTranslation / 1000)
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
                        self.showDetail = false
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
            showDetail: .constant(true),
            eanCode: .constant(""),
            goToResult: .constant(false),
            namespace: namespace,
            cardType: .eanButton
        )
    }
}



//
//  ItemDetailView.swift
//  MELI
//
//  Created by Thony Gonzalez on 29/02/24.
//

import SwiftUI

struct ItemDetailView: View {
    
    let itemData: Result
    
    @StateObject var viewModel: ItemDetailViewModel = ItemDetailViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack (spacing: 20) {
                VStack (alignment: .leading) {
                    title
                }
                
                HStack {
                    DownloadingImageView(url: itemData.thumbnail ?? "", key: itemData.thumbnailID ?? "")
                        .scaledToFit()
                        .frame(width: 130, height: 130)
                    
                    Spacer()
                    
                    VStack (spacing: 20) {
                        if let condition = itemData.condition {
                            Text(condition == "new" ? "Nuevo" : "Usado")
                                .font(.manropeExtraLight(16))
                                .foregroundStyle(.black.opacity(0.7))
                                .padding(.horizontal, 30)
                        }
                        
                        if let freeShipping = itemData.shipping?.freeShipping, freeShipping {
                            Text("Envío gratis")
                                .font(.manropeRegular(16))
                                .foregroundStyle(Color.mainGreen)
                                .padding(5)
                                .background {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.mainGreen.opacity(0.15))
                                }
                        }
                    }
                }
                .padding(.horizontal, 50)
                
                priceSection
                
                buyButton()
            }
            .padding(.horizontal, 10)
            .padding(.top, 30)
        }
    }
    
    private var title: some View {
        Text(itemData.title)
            .font(.manropeSemiBold(20))
            .foregroundStyle(.black)
            .lineLimit(2)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    private var priceSection: some View {
        VStack (spacing: 15) {
            
            if let originalPrice = itemData.originalPrice {
                Text(viewModel.formatAsMoney(originalPrice))
                    .font(.manropeRegular(16))
                    .foregroundStyle(.black.opacity(0.5))
                    .strikethrough()
            }
            
            HStack {
                Text(viewModel.formatAsMoney(itemData.price))
                    .font(.manropeBold(26))
                    .foregroundStyle(.black)
                
                if let originalPrice = itemData.originalPrice, originalPrice < itemData.price {
                    Text("\(viewModel.calculateDiscountPercentage(originalValue: itemData.originalPrice ?? 0, valueWithDiscount: itemData.price))% OFF")
                        .font(.manropeSemiBold(18))
                        .foregroundStyle(Color.mainGreen)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.mainGreen)
                    .opacity(0.06)
            }
            
            if let quantity = itemData.installments?.quantity, let amount = itemData.installments?.amount {
                installmentsSection(installmentsCount: quantity, installmentsAmount: amount)
            }
        }
    }
    
    private func installmentsSection(installmentsCount: Int, installmentsAmount: Double) -> some View {
        HStack {
            Text("en ").foregroundStyle(.black).font(.manropeRegular(18)) +
            Text("\(installmentsCount)x").foregroundStyle(Color.mainGreen).font(.manropeSemiBold(18)) +
            Text(" \(viewModel.formatAsMoney(installmentsAmount))").foregroundStyle(Color.mainGreen).font(.manropeSemiBold(18))
        }
    }
    
    @ViewBuilder
    private func buyButton() -> some View {
        Button {
            dismiss()
        } label: {
            Text("Comprar ahora")
                .font(.manropeBold(16))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.mainBlue)
                }
                .padding(10)
                .padding(.vertical, 50)
        }
    }
}

struct ItemDetailViewPreview: View {
    
    let item = Result(id: "", title: "Apple iPhone 11 (128 Gb) - Blanco Apple iPhone 11 (128 Gb) - Blanco Apple iPhone 11 (128 Gb) - Blanco Apple iPhone 11 (128 Gb) - Blanco", condition: "new", thumbnailID: "", thumbnail: "http://http2.mlstatic.com/D_904849-MLA46153369025_052021-I.jpg", price: 2454900, originalPrice: 3506900, shipping: Shipping(storePickUp: nil, freeShipping: true, logisticType: "", mode: "", tags: nil), installments: Installments(quantity: 12, amount: 204575, rate: 0, currencyID: "COP"))
    
    @State var sheetContentHeight = CGFloat(0)
    
    var body: some View {
        ZStack {
            
        }
        .sheet(isPresented: .constant(true), content: {
            ItemDetailView(itemData: item)
                .background {
                    GeometryReader { proxy in
                        Color.clear
                            .task {
                                print("size = \(proxy.size.height)")
                                    sheetContentHeight = proxy.size.height
                            }
                    }
                }
                .presentationDetents([.height(sheetContentHeight)])
        })
    }
}

#Preview {
    ItemDetailViewPreview()
}

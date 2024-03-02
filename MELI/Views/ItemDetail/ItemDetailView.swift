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
    
    let screenSize: CGRect = (UIScreen.current?.bounds ?? UIScreen.main.bounds)
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            ScrollView {
                VStack (spacing: 20) {
                    
                    VStack (alignment: .leading) {
                        title
                    }
                    .padding(20)
                    
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
                                    .padding(5)
                                    .background {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color.myPrimary.opacity(0.15))
                                    }
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
                    
                    if let attributes = itemData.attributes {
                        attributesListView(attributes: attributes)
                    } else {
                        Text("Without attributes: \(itemData.attributes?.count ?? 0)")
                            .foregroundStyle(.red)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.top, 30)
                .padding(.bottom, 80)
            }
            
            Button("Continuar") {
                dismiss()
            }
            .frame(width: screenSize.width * 0.9)
            .buttonStyle(MELIMainButtonStyle())
            .frame(maxHeight: .infinity, alignment: .bottom)
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
            .padding(20)
            .padding(.horizontal, 10)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.mainGreen)
                    .opacity(0.06)
            }
            .frame(maxWidth: .infinity)
            
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
    
    @State var size: CGSize = .zero
    
    @ViewBuilder
    fileprivate func attributesListView(attributes: [Attribute]) -> some View {
        VStack (spacing: 5) {
            ForEach(attributes, id: \.self) { attribute in
                if let name = attribute.name, let valueName = attribute.valueName {
                    attributeView(name: name, valueName: valueName)
                }
            }
        }
        .padding(5)
        .background {
            RoundedRectangle(cornerRadius: 10.0)
                .stroke(lineWidth: 0.2)
        }
        .frame(maxWidth: screenSize.width * 0.9)
        .frame(width: screenSize.width)
    }
    
    fileprivate func attributeView(name: String, valueName: String) -> some View {
        HStack (spacing: 20) {
            Text(name)
                .font(.manropeSemiBold(14))
                .foregroundStyle(.black)
                .lineLimit(1)
                .frame(maxWidth: screenSize.width * 0.6, alignment: .leading)
            Divider()
            
            Text(valueName)
                .font(.manropeSemiBold(14))
                .foregroundStyle(.black)
                .lineLimit(1)
                .frame(maxWidth: screenSize.width * 0.4, alignment: .leading)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 20)
        .frame(maxWidth: screenSize.width)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .fill(.myPrimary)
        }
    }
}

struct ItemDetailViewPreview: View {
    
    @State var sheetContentHeight = CGFloat(500)
    
    @StateObject var viewModel: SearchBarViewModel
    
    init() {
        self._viewModel = StateObject(wrappedValue: SearchBarViewModel(mainAppService: MainAppService(client: APIClient())))
    }
    
    var body: some View {
        ZStack {
            
        }
        .sheet(item: $viewModel.itemDetail) { item in
            ItemDetailView(itemData: item) 
        }
    }
}

#Preview {
    ItemDetailViewPreview()
}

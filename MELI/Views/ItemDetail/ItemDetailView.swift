//
//  ItemDetailView.swift
//  MELI
//
//  Created by Thony Gonzalez on 29/02/24.
//

import SwiftUI

struct ItemDetailView: View {
    
    @StateObject var viewModel: ItemDetailViewModel
    
    let reloadAction: () -> Void
    
    let itemInstallments: Installments?
    
    init(mainAppService: MainAppServiceProtocol, itemId: String, itemInstallments: Installments?, reloadAction: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: ItemDetailViewModel(mainAppService: mainAppService, itemId: itemId))
        self.reloadAction = reloadAction
        self.itemInstallments = itemInstallments
    }
    
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            if let itemDetailData = viewModel.itemDetailData {
                itemDetailView(itemData: itemDetailData)
            } else if viewModel.lastApiError != nil {
                errorStateView()
            }
            
            Button(viewModel.itemDetailData != nil ? "Continuar" : "Salir") {
                dismiss()
            }
            .frame(width: Constants.screenSize.width * 0.9)
            .buttonStyle(MELIMainButtonStyle())
            .frame(maxHeight: .infinity, alignment: .bottom)
            
            if let pictures = viewModel.itemDetailData?.pictures, viewModel.showPicsView {
                ItemDetailRollPicsView(pictures: pictures) {
                    viewModel.showPicsView = false
                }
            }
        }
    }
    
    @ViewBuilder
    private func itemDetailView(itemData: ItemDetailBody) -> some View {
        ScrollView {
            VStack (spacing: 20) {
                
                if let title = itemData.title {
                    VStack (alignment: .leading) {
                        self.title(title)
                    }
                    .padding(20)
                }
                
                VStack {
                    
                    if let pictures = itemData.pictures {
                        
                        TabView {
                            ForEach(pictures, id: \.self) { photo in
                                Button {
                                    viewModel.showPicsView = true
                                } label: {
                                    DownloadingImageView(url: photo.secureURL ?? "", key: photo.id ?? "")
                                        .scaledToFill()
                                        .frame(width: 130, height: 130)
                                }
                            }
                        }
                        .frame(width: Constants.screenSize.width * 0.75, height: 250)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.gray.opacity(0.5), lineWidth: 0.5)
                        }
                        
                    }
                    
                    Spacer()
                    
                    HStack (spacing: 20) {
                        Text(itemData.condition == "new" ? "Nuevo" : "Usado")
                            .font(.manropeExtraLight(16))
                            .foregroundStyle(.black.opacity(0.7))
                            .padding(5)
                            .background {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.myPrimary.opacity(0.5))
                            }
                            .padding(.horizontal, 30)
                        
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
                
                priceSection(itemData)
                
                if let attributes = itemData.attributes, !attributes.isEmpty {
                    attributesListView(attributes: attributes)
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, 30)
            .padding(.bottom, 80)
        }
    }
    
    private func title(_ title: String) -> some View {
        Text(title)
            .font(.manropeSemiBold(20))
            .foregroundStyle(.black)
            .lineLimit(2)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    private func priceSection(_ itemData: ItemDetailBody) -> some View {
        VStack (spacing: 15) {
            
            if let originalPrice = itemData.originalPrice {
                Text(viewModel.formatAsMoney(Double(originalPrice)))
                    .font(.manropeRegular(16))
                    .foregroundStyle(.black.opacity(0.5))
                    .strikethrough()
            }
            
            HStack {
                Text(viewModel.formatAsMoney(Double(itemData.price ?? 0)))
                    .font(.manropeBold(26))
                    .foregroundStyle(.black)
                
                if let originalPrice = itemData.originalPrice, let price = itemData.price, originalPrice < price {
                    Text("\(viewModel.calculateDiscountPercentage(originalValue: Double(originalPrice), valueWithDiscount: Double(price)))% OFF")
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
            
            if let quantity = itemInstallments?.quantity, let amount = itemInstallments?.amount {
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
        .frame(maxWidth: Constants.screenSize.width * 0.9)
        .frame(width: Constants.screenSize.width)
    }
    
    fileprivate func attributeView(name: String, valueName: String) -> some View {
        HStack (spacing: 20) {
            Text(name)
                .font(.manropeSemiBold(14))
                .foregroundStyle(.black)
                .lineLimit(1)
                .frame(maxWidth: Constants.screenSize.width * 0.6, alignment: .leading)
            Divider()
            
            Text(valueName)
                .font(.manropeSemiBold(14))
                .foregroundStyle(.black)
                .lineLimit(1)
                .frame(maxWidth: Constants.screenSize.width * 0.4, alignment: .leading)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 20)
        .frame(maxWidth: Constants.screenSize.width)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .fill(.myPrimary)
        }
    }
    
    @ViewBuilder
    private func errorStateView() -> some View {
        ZStack {
            VStack {
                Text("Error al cargar item \(Image(systemName: "exclamationmark.triangle.fill"))")
                    .font(.manropeBold(18))
                    .foregroundStyle(.black)
                
                Button("Intenta de nuevo") {
                    dismiss()
                    reloadAction()
                }
                .buttonStyle(MELIMainButtonStyle())
                .frame(width: Constants.screenSize.width * 0.6)
            }
        }
    }
}

struct ItemDetailViewPreview: View {
    
    @State var sheetContentHeight = CGFloat(500)
    
    @StateObject var viewModel: SearchBarViewModel
    
    init() {
        self._viewModel = StateObject(wrappedValue: SearchBarViewModel(mainAppService: MainAppService(client: APIClient())))
        viewModel.itemDetail = .init(id: "", title: "", condition: "", thumbnailID: "", thumbnail: "", price: 0, originalPrice: 0, shipping: nil, installments: nil, attributes: nil)
    }
    
    var body: some View {
        ZStack {
            
            ItemDetailView(mainAppService: MainAppService(client: APIClient()), itemId: "MCO909960201", itemInstallments: nil) {}
        }
        .sheet(item: $viewModel.itemDetail) { item in
        }
    }
}

#Preview {
    ItemDetailViewPreview()
}

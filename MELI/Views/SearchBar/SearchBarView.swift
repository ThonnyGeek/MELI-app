//
//  SearchBarView.swift
//  MELI
//
//  Created by Thony Gonzalez on 28/02/24.
//

import SwiftUI

struct SearchBarView: View {
    
    @StateObject var viewModel: SearchBarViewModel = SearchBarViewModel()
    
    @AppStorage("site_id") var siteIdAppStorage: String?
    
    @EnvironmentObject var inAppNotificationsViewModel: InAppNotificationsViewModel
    
    @Environment(\.dismiss) fileprivate var dismiss
    
    @State var sheetContentHeight = CGFloat(500)
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.mainYellow, .myPrimary], startPoint: .top, endPoint: .center)
                .ignoresSafeArea()
            
            VStack {
                searchBarView()
                
                if !viewModel.searchItemsResults.isEmpty {
                    seachItemsListView()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    withAnimation(.spring) {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 18)
                        .bold()
                        .foregroundStyle(Color.black.opacity(0.5))
                        .padding(.vertical, 5)
                        .padding(.leading, 10)
                        .padding(.trailing, 5)
                }
            }
        }
        .onReceive(viewModel.$isLoading, perform: { isLoading in
            inAppNotificationsViewModel.showLoadingView = isLoading
        })
        .sheet(item: $viewModel.itemDetail) { item in
            ItemDetailView(itemData: item) 
        }
    }
    
    @ViewBuilder
    private func searchBarView() -> some View {
        VStack  (spacing: 100) {
            HStack (spacing: 10) {
                Image(systemName: "magnifyingglass")
                
                TextField("", text: $viewModel.searchBarText, prompt: Text("Buscar").foregroundStyle(.black.opacity(0.2)))
                    .submitLabel(.search)
                    .onSubmit {
                        viewModel.hideKeyboard()
                        if !viewModel.searchBarText.isEmpty {
                            viewModel.fetchSearchItems { apiError in
                                inAppNotificationsViewModel.showError(apiError.apiErrorDescription.error, subtitle: apiError.apiErrorDescription.message)
                            }
                        } else {
                            inAppNotificationsViewModel.showError("Campo vacío", subtitle: "El campo de búsqueda debe contener al menos 1 caracter")
                        }
                    }
                
                Button {
                    viewModel.resetFields()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .padding(.vertical, 3)
                        .padding(.horizontal, 8)
                }
            }
            .foregroundStyle(.black.opacity(0.5))
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
            }
            .padding(10)
            
            if viewModel.searchItemsResults.isEmpty {
                
                Button("Buscar") {
                    viewModel.hideKeyboard()
                    
                    if !viewModel.searchBarText.isEmpty {
                        viewModel.fetchSearchItems { apiError in
                            inAppNotificationsViewModel.showError(apiError.apiErrorDescription.error, subtitle: apiError.apiErrorDescription.message)
                        }
                    } else {
                        inAppNotificationsViewModel.showError("Campo vacío", subtitle: "El campo de búsqueda debe contener al menos 1 caracter")
                    }
                }
                .buttonStyle(MELIMainButtonStyle())
            }
        }
    }
    
    @ViewBuilder
    fileprivate func seachItemsListView() -> some View {
        GeometryReader { geometry in
            ScrollView {
                Group {
                    LinearGradient(colors: [.black.opacity(0.1), .black.opacity(0.05), .black.opacity(0)], startPoint: .top, endPoint: .bottom)
                        .frame(height: 25)
                    
                    LazyVStack (alignment: .leading) {
                        
                        ForEach(viewModel.searchItemsResults, id: \.self) { searchItemResult in
                            Button {
                                viewModel.itemDetail = searchItemResult
                            } label: {
                                searchItemResultView(imageUrlString: searchItemResult.thumbnail ?? "", title: searchItemResult.title, price: searchItemResult.price, freeShipping: searchItemResult.shipping?.freeShipping ?? false, installments: searchItemResult.installments)
                            }
                            
                            if let last = viewModel.searchItemsResults.last, last != searchItemResult {
                                Divider()
                            }
                        }
                        
                        if viewModel.pagingResults.offset <= 1000 && viewModel.searchItemsResults.count < viewModel.pagingResults.total {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .onAppear {
                                    viewModel.loadMoreSearchItems { apiError in
                                        inAppNotificationsViewModel.showError(apiError.apiErrorDescription.error, subtitle: apiError.apiErrorDescription.message)
                                    }
                                }
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .frame(width: geometry.size.width * 0.9)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                }
                .frame(maxHeight: .infinity)
                .background(Color.white)
            }
            .scrollIndicators(.visible)
        }
        .background {
            Color.white
            Color.black.opacity(0.1)
        }
    }
    
    @ViewBuilder
    fileprivate func searchItemResultView(imageUrlString: String, title: String, price: Double, freeShipping: Bool, installments: Installments?) -> some View {
        HStack (alignment: .top, spacing: 15) {
            
            DownloadingImageView(url: imageUrlString, key: URL(string: imageUrlString)?.lastPathComponent ?? imageUrlString)
                .scaledToFit()
                .frame(width: 110, height: 160)
            
            
            VStack (alignment: .leading, spacing: 10) {
                
                VStack (alignment: .leading, spacing: 10) {
                    Text("\(title)")
                        .font(.manropeRegular(16))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text(viewModel.formatAsMoney(price))
                        .font(.manropeSemiBold(20))
                    
                    if let installmentsQuantity = installments?.quantity, let installmentsAmount = installments?.amount {
                        Text("en \(installmentsQuantity)x - \(viewModel.formatAsMoney(installmentsAmount))")
                            .font(.manropeRegular(12))
                    }
                }
                .foregroundStyle(.black)
                
                if freeShipping {
                    Text("Envío gratis")
                        .font(.manropeRegular(14))
                        .foregroundStyle(Color.mainGreen)
                        .padding(5)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.mainGreen.opacity(0.15))
                        }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
    }
}

#Preview {
//    SearchBarView().seachItemsListView()
        WelcomeView()
        .environmentObject(InAppNotificationsViewModel())
}

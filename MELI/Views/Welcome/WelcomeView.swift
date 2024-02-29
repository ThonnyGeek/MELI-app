//
//  WelcomeView.swift
//  MELI
//
//  Created by Thony Gonzalez on 27/02/24.
//

import SwiftUI

struct WelcomeView: View {
    
    @StateObject var viewModel: WelcomeViewModel = WelcomeViewModel()
    
    @EnvironmentObject var inAppNotificationsViewModel: InAppNotificationsViewModel
    
    /// Setting default site_id to Colombia
    @AppStorage("site_id") var siteIdAppStorage: String = "MCO"
    
    var body: some View {
        NavigationStack {
            
            let _ = Self._printChanges()
            
            ZStack {
                
                Color.mainYellow
                    .ignoresSafeArea()
                
                VStack {
                    DownloadingImageView(url: "https://http2.mlstatic.com/frontend-assets/homes-palpatine/logo_homecom_v2.png", key: "logo_homecom_v2.png")
                        .scaledToFit()
                        .frame(width: 150)
                    
                    listView()
                }
                
            }
        }
        .onReceive(viewModel.$lastApiError, perform: { apiError in
            guard let apiError = apiError else { return }
            print("apiError: \(apiError)")
            inAppNotificationsViewModel.showError(apiError.apiErrorDescription.error, subtitle: apiError.apiErrorDescription.message)
        })
        .overlay {
            InAppNotificationsView()
        }
    }
    
    @ViewBuilder
    private func listView() -> some View {
        if !viewModel.sites.isEmpty {
            ScrollView {
                VStack {
                    ForEach(viewModel.sites, id: \.self) { site in
                        
                        NavigationLink(destination: SearchBarView().navigationBarBackButtonHidden().onAppear {siteIdAppStorage = site.id}) {
                            listButton(site.name, image: site.id.dropFirst().description)
                        }

                        
                        if site != viewModel.sites.last {
                            Divider()
                        }
                        
                    }
                }
            }
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
            }
            .padding(20)

        }
    }
    
    @ViewBuilder
    private func listButton(_ text: String, image: String) -> some View {
        HStack {
            
            HStack (spacing: 10) {
                Image("\(image)")
                
                Text("\(text)")
                    .foregroundStyle(.black)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .opacity(0.5)
        }
        .foregroundStyle(.black)
        .padding(10)
    }
}

#Preview {
    WelcomeView()
        .environmentObject(InAppNotificationsViewModel())
}

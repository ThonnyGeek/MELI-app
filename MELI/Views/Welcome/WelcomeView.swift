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
    
    var body: some View {
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
        .onChange(of: viewModel.lastApiError) { oldValue, newValue in
//                newValue
            
        }
        .overlay {
            InAppNotificationsView()
        }
    }
    
    @ViewBuilder
    private func listView() -> some View {
        ScrollView {
            VStack {
                ForEach(viewModel.sites, id: \.self) { site in
                    Button {
                    } label: {
                        listButton(site.name, image: site.id.dropFirst().description) {}
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
    
    @ViewBuilder
    private func listButton(_ text: String, image: String, onTap: @escaping () -> Void) -> some View {
        Button {
            onTap()
        } label: {
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
}

#Preview {
    WelcomeView()
        .environmentObject(InAppNotificationsViewModel())
}

//
//  DownloadingImageView.swift
//  MELI
//
//  Created by Thony Gonzalez on 22/02/24.
//

import SwiftUI

struct DownloadingImageView: View {
    
    @StateObject var loader: ImageLoadingViewModel
    let url: String

    init(url: String, key: String) {
        self.url = url
        _loader = StateObject(wrappedValue: ImageLoadingViewModel(url: url, key: key))
    }
    
    var body: some View {
        ZStack {
            
            if let image = loader.image, let url = URL(string: url), url.scheme != nil, url.host != nil {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                defaultImage
            }
            
            if loader.isLoading {
                defaultImage
                
                ProgressView()
            }
        }
    }
    
    private var defaultImage: some View {
        ZStack {
            Image(systemName: "nosign")
                .opacity(0.2)
        }
    }
}

struct DownloadingImageView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadingImageView(url: "", key: "1")
            .frame(width: 100, height: 100)
            .previewLayout(.sizeThatFits)
    }
}

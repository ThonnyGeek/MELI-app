//
//  ImageLoadingViewModel.swift
//  TodoServy
//
//  Created by Thony Gonzalez on 22/02/24.
//  Copyright © 2024 Magora. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final class ImageLoadingViewModel: ObservableObject {
    
    //MARK: Variables
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: Constants
    let manager = PhotoModelCacheManager.shared
    
    let urlString: String
    let imageKey: String
    
    //MARK: init
    init(url: String, key: String) {
        urlString = url
        imageKey = key
        getImage()
    }
    
    //MARK: Functions
    
    func getImage() {
        if let savedImage = manager.get(key: imageKey) {
            image = savedImage
            print("Getting saved image!")
        } else {
            downloadImage()
            print("Downloading Image!")
        }
    }
    
    func downloadImage() {
        
        isLoading = true
        
        guard let url = URL(string: urlString), !urlString.isEmpty/*, url.scheme != nil, url.host != nil*/
        else {
            isLoading = false
            image = UIImage(systemName: "photo.fill")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedImage) in
                guard
                    let self = self,
                    let image = returnedImage else { return }
                
                self.image = image
                self.manager.add(key: self.imageKey, value: image)
            }
            .store(in: &cancellables)

    }
}

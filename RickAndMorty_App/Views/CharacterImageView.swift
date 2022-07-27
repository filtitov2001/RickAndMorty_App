//
//  CharacterImageView.swift
//  RickAndMorty_App
//
//  Created by Felix Titov on 7/27/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import UIKit

class CharacterImageView: UIImageView {

    func fetchImage(from url: String) {
        guard let url = URL(string: url) else {
            image = #imageLiteral(resourceName: "picture")
            return
        }
        
        // Use image from cache, if exist
        if let chachedImage = getCachedImage(from: url) {
            image = chachedImage
            return
        }
        
        // else download from net
        ImageManager.shared.fetchImage(from: url) { data, response in
            self.image = UIImage(data: data)
            self.saveDataToCache(with: data, and: response)
        }
    }
    
    private func saveDataToCache(with data: Data, and response: URLResponse) {
        guard let responseURL = response.url else { return }
        let request = URLRequest(url: responseURL)
        let chachedResponse = CachedURLResponse(response: response, data: data)
        
        URLCache.shared.storeCachedResponse(chachedResponse, for: request)
    }
    
    private func getCachedImage(from url: URL) -> UIImage? {
        let request = URLRequest(url: url)
        
        if let chachedResponse = URLCache.shared.cachedResponse(for: request) {
            return UIImage(data: chachedResponse.data)
        }
        
        return nil
    }

}

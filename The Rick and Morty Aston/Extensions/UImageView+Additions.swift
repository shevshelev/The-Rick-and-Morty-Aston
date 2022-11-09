//
//  UImageView+Additions.swift
//  The Rick and Morty Aston
//
//  Created by Shevshelev Lev on 12.10.2022.
//

import UIKit

extension UIImageView {
    
    func fetchImage(from urlString: String) {
        Task {
            guard let url = URL(string: urlString) else { return }
            if let cachedImage = await getCachedImage(from: url) {
                DispatchQueue.main.async {
                    self.image = cachedImage
                }
            }
            // error ios 15
            let (data, response) = try await URLSession.shared.data(from: url)
            if url.lastPathComponent == response.url?.lastPathComponent {
                await saveDataToCache(with: data, and: response)
                guard let image = UIImage(data: data)
                else { throw NetworkManager.NetworkError.noData }
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.image = nil
                }
            }
        }
    }
    
    private func saveDataToCache(with data: Data, and response: URLResponse) async {
        guard let url = response.url else { return }
        let request = URLRequest(url: url)
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: request)
    }
    
    private func getCachedImage(from url: URL) async -> UIImage? {
        let request = URLRequest(url: url)
        guard let cachedResponse = URLCache.shared.cachedResponse(for: request)
        else { return nil }
        guard url.lastPathComponent == cachedResponse.response.url?.lastPathComponent
        else { return nil }
        return UIImage(data: cachedResponse.data)
    }
}

//
//  ImageDownloader.swift
//  Nasa
//
//  Created by Jhon Ospino Bernal on 18/06/20.
//  Copyright © 2020 Jhon Ospino Bernal. All rights reserved.
//

import UIKit

class ImageDownloader{

   private var imageDataTask: URLSessionDataTask?
    //private let cache = ImageCache.cache

    private(set) var isCancelled = false

    func downloadPhoto(with url: URL, completion: @escaping ((UIImage?, Bool) -> Void)) {
        guard imageDataTask == nil else { return }

        isCancelled = false

//        if let cachedResponse = cache.cachedResponse(for: URLRequest(url: url)),
//            let image = UIImage(data: cachedResponse.data) {
//            completion(image, true)
//            return
//        }

        imageDataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            strongSelf.imageDataTask = nil

            guard let data = data, let response = response, let image = UIImage(data: data), error == nil else {
                return
                
            }

//            let cachedResponse = CachedURLResponse(response: response, data: data)
//            strongSelf.cache.storeCachedResponse(cachedResponse, for: URLRequest(url: url))

            DispatchQueue.main.async {
                completion(image, false)
            }
        }

        imageDataTask?.resume()
    }

    func cancel() {
        isCancelled = true
        imageDataTask?.cancel()
    }

}

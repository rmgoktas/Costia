//
//  ImageLoader.swift
//  Costia
//
//  Created by R. Metehan GÖKTAŞ on 31.10.2024.
//

import UIKit

class ImageLoader {
    private var imageCache = NSCache<NSString, UIImage>()

    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: url) else {
            completion(nil)
            return
        }

        if let cachedImage = imageCache.object(forKey: NSString(string: url)) {
            completion(cachedImage)
            return
        }

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: imageURL),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageCache.setObject(image, forKey: NSString(string: url))
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}


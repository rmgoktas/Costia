//
//  DataManager.swift
//  Costia
//
//  Created by R. Metehan GÖKTAŞ on 30.10.2024.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    private init() {}
    
    private var baseURL: String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path),
              let url = config["BaseURL"] as? String else {
            fatalError("Base URL not found in Config.plist")
        }
        return url
    }
    
    func fetchProducts(withBarcode barcode: String, completion: @escaping (Result<[Product], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/products?barcode=\(barcode)") else {
            completion(.failure(NSError(domain: "URL Error", code: -1, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Data Error", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let products = try JSONDecoder().decode([Product].self, from: data)
                completion(.success(products))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func searchProducts(with query: String, completion: @escaping ([Product]) -> Void) {
        guard let url = URL(string: "\(baseURL)/products?name_like=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching products: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                // ProductResponse yerine doğrudan Product dizisi olarak decode ediyoruz.
                let products = try JSONDecoder().decode([Product].self, from: data)
                // Arama sonucu için, ürün adında sorgulanan kelime var mı kontrol et
                let filteredProducts = products.filter { product in
                    product.name.lowercased().contains(query.lowercased())
                }
                completion(filteredProducts)
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        task.resume()
    }

}

//
//  ProductViewModel.swift
//  AsyncAwaitvsCallbacks
//
//  Created by Fatih Durmaz on 23.07.2024.
//

import Foundation
import Observation

@Observable
class ProductViewModel {
    var products: [Product] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    
    func fetchProductsWithCallbacks(completion: @escaping (Result<[Product], Error>) -> Void)  {
        
        isLoading = true
        
        guard let url = URL(string: "https://dummyjson.com/product") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            defer {
                self.isLoading = false
            }
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let productResponse = try JSONDecoder().decode(ProductResponse.self, from: data)
                completion(.success(productResponse.products))
            }catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
        
    }
    
    func fetchProductsWithAsyncAwait () async{
        isLoading = true
        guard let url = URL(string: "https://dummyjson.com/product") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let productResponse = try JSONDecoder().decode(ProductResponse.self, from: data)
            self.products = productResponse.products
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    
}

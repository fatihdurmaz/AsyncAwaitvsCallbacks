# Async-Await vs Callbacks in SwiftUI

## Project Structure

***ProductViewModel.swift:*** Contains the ProductViewModel class with methods to fetch products using callbacks and async-await.

***Product.swift:*** Defines the Product and ProductResponse models for decoding the API response.

***ContentView.swift:*** The SwiftUI view displaying the list of products and demonstrating the usage of both asynchronous techniques.

## Explanation

**ProductViewModel**

The ProductViewModel class contains two methods for fetching products:

***fetchProductsWithCallbacks:*** Uses a callback function to handle the asynchronous task. The method sets the isLoading flag to true before making the network request and resets it to false after the request completes. The completion handler is called with the result of the request, either the fetched products or an error.
``` swift
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
```

***fetchProductsWithAsyncAwait:*** Uses the async-await syntax to handle the asynchronous task. The method sets the isLoading flag to true before making the network request and resets it to false after the request completes. If the request is successful, the fetched products are assigned to the products property; otherwise, the errorMessage property is set with the error description.

``` swift
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
```

**ContentView**

The ContentView is a SwiftUI view that displays the list of products. It uses the ProductViewModel to fetch products and demonstrates the usage of both asynchronous techniques. The view shows a loading indicator while the data is being fetched and displays an error message if the request fails.

## Usage

To fetch products using callbacks, call the **fetchProductsWithCallbacks** method:
``` swift
  viewModel.fetchProductsWithCallbacks { result in
      switch result {
      case .success(let products):
          viewModel.products = products
      case .failure(let error):
          viewModel.errorMessage = error.localizedDescription
      }
  }

```
To fetch products using async-await, call the **fetchProductsWithAsyncAwait** method:
``` swift
  Task {
      await viewModel.fetchProductsWithAsyncAwait()
  }

```



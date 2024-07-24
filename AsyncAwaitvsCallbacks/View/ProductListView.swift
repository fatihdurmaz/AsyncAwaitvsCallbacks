//
//  ProductListView.swift
//  AsyncAwaitvsCallbacks
//
//  Created by Fatih Durmaz on 23.07.2024.
//

import SwiftUI

struct ProductListView: View {
    @State private var viewModel = ProductViewModel()
    var body: some View {
        
        Group {
            if viewModel.isLoading {
                ProgressView("Yükleniyor")
                
            }else if let errorMessage = viewModel.errorMessage {
                ContentUnavailableView("Hata Oluştu!", systemImage: "xmark.circle.fill", description: Text(errorMessage))
            } else {
                List(viewModel.products) { product in
                    HStack(alignment: .center) {
                        AsyncImage(url: URL(string: product.thumbnail)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 100, height: 100)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(.rect(cornerRadius: 8))
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .shadow(radius: 10)
                        
                        VStack(alignment: .leading) {
                            Text(product.title)
                                .font(.headline)
                            
                            Text(product.price.formatted(.currency(code: "USD")))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .bold()
                            
                            Spacer()
                            
                            HStack(alignment: .top) {
                                Text(product.category)
                                    .bold()
                                    .italic()
                                
                                Spacer()
                                
                                Text(product.rating.formatted())
                                
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                
                            }
                        }
                    }
                }
                
            }
            
        }
        .onAppear{
            Task {
                await viewModel.fetchProductsWithAsyncAwait()
            }
        }
    }
}

#Preview {
    ProductListView()
}

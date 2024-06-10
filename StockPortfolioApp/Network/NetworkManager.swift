//
//  NetworkManager.swift
//  StockPortfolioApp
//
//  Created by Raj Shekhar on 24/05/24.
//

import Foundation

protocol NetworkManagerProtocol {
    func makeRequest<Q: Codable>(url: URL, completion: @escaping (Result<Q, Error>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func makeRequest<Q: Codable>(url: URL, completion: @escaping (Result<Q, Error>) -> Void) {
        let urlRequest = URLRequest(url: url)
        
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(Q.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

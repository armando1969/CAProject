//
//  NetworkManager.swift
//  CAProject
//
//  Created by Florencio Gallegos on 8/26/24.
//

import Foundation
import Combine

protocol NetworkLayer {
    func get<T>(url: String, modelType: T.Type) -> AnyPublisher<T, NetworkError> where T: Decodable
}

struct NetworkManager: NetworkLayer {
    func get<T>(url: String, modelType: T.Type) -> AnyPublisher<T, NetworkError> where T : Decodable {
        guard let url = URL(string: url) else {
            return Fail(error: NetworkError.badURL) .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["X-Api-Key": "A1P2vjZwCzHbw0fSmAkQJw==6uv5LsT2KMvkPTzd"]
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data: Data, response: URLResponse) in
                return data
            }
            .decode(type: modelType.self, decoder: JSONDecoder())
            .mapError({ error in
                return NetworkError.apiError(error.localizedDescription)
            })
            .eraseToAnyPublisher()
    }
    
    
}

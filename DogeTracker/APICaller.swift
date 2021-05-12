//
//  APICaller.swift
//  DogeTracker
//
//  Created by Carlos Cardona on 08/05/21.
//

import Foundation


final class APICaller {
    static var shared = APICaller()
    
    private init() {}
    
    enum APIError: Error {
        case invalidURL
    }
    
    public func getDogecoinData(completion: @escaping (Result<DogecoinData, Error>) -> Void) {
        
        guard let url = URL(string: Constants.BASE_URL + Constants.ENDPOINT + "?slug=" + Constants.DOGE) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("\n\n API URL: \(url.absoluteURL) \n\n")
        
        var request = URLRequest(url: url)
        request.setValue(Constants.API_KEY, forHTTPHeaderField: Constants.API_KEY_HEADER)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                
                let response = try JSONDecoder().decode(APIResponse.self, from: data)
                
                guard let dogeCoinData = response.data.values.first else { return }
                
                completion(.success(dogeCoinData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
        
    }
}

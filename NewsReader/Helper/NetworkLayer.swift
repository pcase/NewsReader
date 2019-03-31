//
//  NetworkLayer.swift
//  RabbitHavenServices
//
//  From https://codeburst.io/write-your-own-network-layer-in-swift-36ae4e205876
//
//  Created by Patty Case on 9/23/18.
//  Copyright © 2018 Azure Horse Creations. All rights reserved.
//

import Foundation

typealias NetworkCompletionHandler = (Data?, URLResponse?, Error?) -> Void
typealias ErrorHandler = (String) -> Void

class NetworkLayer {
    
    func request<T: Decodable>(httpMethod: String,
                            urlString: String,
                            headers: [String: String] = [:],
                            parameters: [String: Any] = [:],
                            successHandler: @escaping (T) -> Void,
                            errorHandler: @escaping ErrorHandler) {
        
        let completionHandler: NetworkCompletionHandler = { (data, urlResponse, error) in
            if let error = error {
                print(error.localizedDescription)
                errorHandler(Errors.GENERIC_ERROR)
                return
            }
            
            if self.isSuccessCode(urlResponse) {
                guard let data = data else {
                    print(Errors.PARSE_RESPONSE_ERROR)
                    return errorHandler(Errors.GENERIC_ERROR)
                }
                if let responseObject = try? JSONDecoder().decode(T.self, from: data) {
                    successHandler(responseObject)
                    return
                } else {
                    print(data)
                    return errorHandler(Errors.DECODING_RESPONSE_ERROR)
                }
            }
        }
        
        guard let url = URL(string: urlString) else {
            return errorHandler(Errors.URL_CREATION_ERROR)
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 90
        request.httpMethod = httpMethod
        request.allHTTPHeaderFields = headers
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request,
                                   completionHandler: completionHandler)
            .resume()
    }
    
    private func isSuccessCode(_ statusCode: Int) -> Bool {
        return statusCode >= 200 && statusCode < 300
    }
    
    private func isSuccessCode(_ response: URLResponse?) -> Bool {
        guard let urlResponse = response as? HTTPURLResponse else {
            return false
        }
        return isSuccessCode(urlResponse.statusCode)
    }
}

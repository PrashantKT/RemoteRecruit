//
//  ApiClient.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 05/06/26.
//

import Foundation

protocol ApiClientType {
    func sendRequest<T: Decodable>(endPoint: EndPointType) async throws -> T
}

final class ApiClient: NSObject,ApiClientType {
    
    var reqBuilder: RequestBuilderProtocol
    var urlSession: URLSession
    
    
    init(reqBuilder: RequestBuilderProtocol = RequestBuilder(),urlSession: URLSession = .shared) {
        self.urlSession = urlSession
        self.reqBuilder = reqBuilder
        super.init()
    }
    
    func sendRequest<T: Decodable>(endPoint: EndPointType) async throws -> T {
        let req = try reqBuilder.buildRequest(for: endPoint)
        let (data,res) = try await urlSession.data(for: req)
        
        guard let res = res as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        guard (200...299).contains(res.statusCode) else {
            throw NetworkError.httpError(res.statusCode)
        }
        
        do {
            
            let jsonDecoder = JSONDecoder()
            
            let parsing = try jsonDecoder.decode(T.self, from: data)
            return parsing

        } catch {
            throw NetworkError.decodingError
        }
        
    }
}

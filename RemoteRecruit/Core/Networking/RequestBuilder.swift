//
//  RequestBuilder.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 05/06/26.
//

import Foundation

protocol RequestBuilderProtocol {
    func buildRequest(for endPoint: EndPointType) throws -> URLRequest
}

final class RequestBuilder: RequestBuilderProtocol {
    
    func buildRequest(for endPoint: EndPointType)throws -> URLRequest {
       
        guard var components = URLComponents(string: APIConfig.baseURL) else {
            throw NetworkError.invalidURL
        }
        components.path.append(endPoint.path)

        components.queryItems = endPoint.queryParams

        guard let finalURL = components.url else {
            throw NetworkError.invalidURL
        }
        var urlRequest = URLRequest(url: finalURL)

        urlRequest.httpMethod = endPoint.httpMethod.rawValue
        urlRequest.httpBody = endPoint.httpBody

        var allHeaders = ["Content-Type": "application/json"]
        for (key, value) in endPoint.httpHeader {
            allHeaders[key] = value
        }
        urlRequest.allHTTPHeaderFields = allHeaders
        return urlRequest
    }
    
}

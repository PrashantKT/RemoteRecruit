//
//  EndPoint.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 05/06/26.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol EndPointType {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var queryParams: [URLQueryItem] { get }
    var httpBody: Data? { get }
    var httpHeader: [String: String] { get }
}

extension EndPointType {
    var queryParams: [URLQueryItem] { [] }
    var httpBody: Data? { nil }
    var httpHeader: [String: String] {
        ["Content-Type": "application/json"]
    }
}

nonisolated
struct PagingInfo {
    let limit: Int
    let offset: Int

    static let initial = PagingInfo(
        limit: 20,
        offset: 0
    )
    
    func nextPage() -> PagingInfo {
        PagingInfo(limit: limit, offset: offset + limit)
    }
}

enum JobEndPoint: EndPointType {

    case jobs(PagingInfo)
    case searchJobs(query: String)

    var path: String {
        switch self {
        case .jobs:
            return "/api" //BASEURL = https:/$()/himalayas.app/api

        case .searchJobs:
            return "/api/search"
        }
    }

    var httpMethod: HTTPMethod {
        .get
    }

    var queryParams: [URLQueryItem] {

        switch self {

        case .jobs(let paging):
            return [URLQueryItem( name: "limit",value: "\(paging.limit)"),
                    URLQueryItem( name: "offset",value: "\(paging.offset)")
                    ]

        case .searchJobs(let query):
            return [ URLQueryItem( name: "q",value: query)]
        }
    }
}

//
//  ApiConstants.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 05/06/26.
//
import Foundation

enum APIConfig {
    static let baseURL: String = {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String else {
            assertionFailure("BaseURL missing from Info.plist")
            return ""
        }
        return url
    }()
}

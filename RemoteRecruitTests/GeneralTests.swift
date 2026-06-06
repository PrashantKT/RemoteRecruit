//
//  ApiConfig.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 06/06/26.
//

import Testing
@testable import RemoteRecruit
import Foundation

@Test func testApiConfig() {
    #expect(Bundle.main.object(forInfoDictionaryKey: "BaseURL") != nil)
    #expect(APIConfig.baseURL.isEmpty == false)
}

//
//  ApiConfig.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 06/06/26.
//

import Testing
@testable import RemoteRecruit
import Foundation
import SwiftUI

@Test func testApiConfig() {
    #expect(Bundle.main.object(forInfoDictionaryKey: "BaseURL") != nil)
    #expect(APIConfig.baseURL.isEmpty == false)
}


@Test
func testColorOfAvtar() {
    let colors = AppTheme.getColors(from: "one")
    let colors2 = AppTheme.getColors(from: "one_a")
    #expect(colors != colors2)

}

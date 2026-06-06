//
//  RemoteRecruitApp.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 05/06/26.
//

import SwiftUI

@main
struct RemoteRecruitApp: App {
    @State private var networkMonitor = NetworkMonitor()
    var body: some Scene {
        WindowGroup {
            JobListView()
                .environment(networkMonitor)
        }
    }
}

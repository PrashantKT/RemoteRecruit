//
//  Job.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 05/06/26.
//

import Foundation

struct Job: Identifiable {
    var id: String { guid }

    let guid: String
    let title: String
    let companyName: String
    let companyLogo: String?

    let location: String

    let description: String
    let applicationLink: String
}

struct JobPage {
    let jobs: [Job]
    let offset: Int
    let limit: Int
    let totalCount: Int
}

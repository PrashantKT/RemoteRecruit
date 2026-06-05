//
//  JobDTO.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 05/06/26.
//

import Foundation

struct JobPageDTO: Decodable {
    let jobs: [JobDTO]
    let updatedAt: Int
    let offset: Int
    let limit: Int
    let totalCount: Int
}

struct JobDTO: Decodable {
    let guid: String
    let title: String
    let companyName: String
    let companyLogo: String?
    let employmentType: String?
    let minSalary: Double?
    let maxSalary: Double?
    let currency: String?
    let categories: [String]
    let locationRestrictions: [String]
    let description: String
    let applicationLink: String
    let pubDate: Date
    let expiryDate: Date
}

//
//  MockJobRepo.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 06/06/26.
//

import Foundation
import Testing
@testable import RemoteRecruit

final class MockJobRepo: JobRepoType {
    var getJobsResponses: [JobPage]
    let searchResponse: [Job]
    var errorToThrow: NetworkError?

    private(set) var requestedPages: [PagingInfo] = []
    private(set) var searchQueries: [String] = []

    init(getJobsResponses: [JobPage], searchResponse: [Job], errorToThrow: NetworkError? = nil) {
        self.getJobsResponses = getJobsResponses
        self.searchResponse = searchResponse
        self.errorToThrow = errorToThrow
    }

    func getJobs(page: PagingInfo) async throws -> JobPage {
        if let errorToThrow { throw errorToThrow }
        requestedPages.append(page)
        return getJobsResponses.removeFirst()
    }

    func search(query: String) async throws -> [Job] {
        searchQueries.append(query)
        return searchResponse
    }
}

//
//  JobNetworkRepo.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 05/06/26.
//

import Foundation

final class JobNetworkRepo: JobRepoType {

    private let apiClient: ApiClientType

    init(client: ApiClientType) {
        self.apiClient = client
    }

    func getJobs(page: PagingInfo) async throws -> JobPage {

        let response: JobPageDTO =
            try await apiClient.sendRequest(
                endPoint: JobEndPoint.jobs(page)
            )

        return JobPage(
            jobs: response.jobs.map{$0.toDomain()},
            offset: response.offset,
            limit: response.limit,
            totalCount: response.totalCount
        )
    }

    func search(query: String) async throws -> [Job] {

        let response: JobPageDTO =
            try await apiClient.sendRequest(
                endPoint: JobEndPoint.searchJobs(query: query)
            )

        return response.jobs.map { $0.toDomain()}
    }
}


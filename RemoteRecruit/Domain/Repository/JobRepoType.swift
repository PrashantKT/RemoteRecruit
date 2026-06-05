//
//  JobRepoType.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 05/06/26.
//


protocol JobRepoType {
    func getJobs(page: PagingInfo) async throws -> JobPage
    func search(query: String) async throws -> [Job]

}

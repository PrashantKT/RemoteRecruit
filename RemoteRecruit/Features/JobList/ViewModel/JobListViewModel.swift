//
//  JobListViewModel.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 05/06/26.
//

import SwiftUI

@Observable
class JobListViewModel {
       
    private(set) var jobs: [Job] = []
    private(set) var search: [Job] = []
    
    private let jobListRepo: JobRepoType
    
    var state:StateMachine = .idle
    var searchText = ""

    private(set) var currentPage = PagingInfo.initial
    private var totalCount: Int = 0
    private(set) var  isLoadingNextPage = false
    var hasMorePages: Bool { currentPage.offset + currentPage.limit < totalCount }
    
    init( jobListRepo: JobRepoType) {
        self.jobListRepo = jobListRepo
    }
 
    
    private func fetch(page: PagingInfo) async throws -> JobPage {
        try await jobListRepo.getJobs(page: page)
    }
    
    func getJobs(force: Bool = false) async {

        if case .success = state, !force {
            return
        }
        state = .loading
        do {
            let page = try await fetch(page: currentPage)
            jobs = page.jobs
            totalCount = page.totalCount

            state = jobs.isEmpty ? .empty : .success
        } catch let error as NetworkError {
            state = .failure(error.userFriendlyMessage)
        } catch {
            state = .failure("Something went wrong...")
        }
    }
    
    func loadNextPageIfNeeded(currentJob: Job) async {
        guard let lastJob = jobs.last else {
            return
        }
        guard lastJob.guid == currentJob.guid else {
            return
        }
        print("Started new page \(currentJob.title)")

        await loadNextPage()
    }

    private func loadNextPage() async {
        print("Current Page \(currentPage)")
        guard !isLoadingNextPage, hasMorePages else {
            return
        }
        isLoadingNextPage = true
        defer { isLoadingNextPage = false }
        do {
            let page = try await jobListRepo.getJobs(
                page: currentPage.nextPage()
            )
            jobs.append(contentsOf: page.jobs)
            totalCount = page.totalCount
            currentPage = currentPage.nextPage()
            
        } catch {
            print(error)
        }
        
    }
}

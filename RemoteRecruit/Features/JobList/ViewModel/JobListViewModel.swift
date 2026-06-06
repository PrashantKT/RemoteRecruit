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
    private var cachedJobs: [Job] = []

    private let jobListRepo: JobRepoType

    var state: StateMachine = .idle
    var searchText = ""

    private(set) var currentPage = PagingInfo.initial
    private var totalCount: Int = 0
    private(set) var isLoadingNextPage = false
    var hasMorePages: Bool { currentPage.offset + currentPage.limit < totalCount }
    
    private var activeSearchTask:Task<Void,Never>?
    init(jobListRepo: JobRepoType) {
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
            cachedJobs = page.jobs
            totalCount = page.totalCount
            currentPage = PagingInfo(limit: page.limit, offset: page.offset)

            state = jobs.isEmpty ? .empty : .success
        } catch let error as NetworkError {
            state = .failure(error.userFriendlyMessage)
        } catch {
            state = .failure("Something went wrong...")
        }
    }

    func loadNextPageIfNeeded(currentJob: Job) async {
        let cleanQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard cleanQuery.isEmpty else {
            return
        }
        guard let lastJob = jobs.last else {
            return
        }
        guard lastJob.id == currentJob.id else {
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
            let nextPage = currentPage.nextPage()
            let page = try await jobListRepo.getJobs(page: nextPage)
            jobs.append(contentsOf: page.jobs)
            cachedJobs.append(contentsOf: page.jobs)
            totalCount = page.totalCount
            currentPage = PagingInfo(limit: page.limit, offset: page.offset)
        } catch {
            print(error)
        }
    }

    func searchJobs() async {
        activeSearchTask?.cancel()

        let cleanQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanQuery.isEmpty else {
            jobs = cachedJobs
            state = jobs.isEmpty ? .empty : .success
            return
        }
        let task = Task {
            state = .loading
            do {
                try await Task.sleep(for: .milliseconds(300))
                try Task.checkCancellation()
                
                let searchJobs = try await jobListRepo.search(query: cleanQuery)
                try Task.checkCancellation()
                
                jobs = searchJobs
                state = jobs.isEmpty ? .empty : .success
            } catch {
                if error is CancellationError {
                    print("User is still typing... cancelled search for: \(cleanQuery)")
                } else {
                    state = .failure("Something went wrong...")
                }
            }
        }

        activeSearchTask = task
        await task.value
    }
}

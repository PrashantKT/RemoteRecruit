//  JobListViewModelTests.swift
//  RemoteRecruitUITests
//
//  Created by Prashant Tukadiya on 05/06/26.
//

import Foundation
import Testing
@testable import RemoteRecruit

@MainActor
struct JobListViewModelTests {

    @Test func getJobsPopulatesListAndSuccessState() async throws {
        let jobs = [makeJob(id: "1"), makeJob(id: "2")]
        let repo = MockJobRepo(
            getJobsResponses: [
                JobPage(jobs: jobs, offset: 0, limit: 20, totalCount: 2)
            ],
            searchResponse: []
        )
        let viewModel = JobListViewModel(jobListRepo: repo)

        await viewModel.getJobs()

        #expect(viewModel.jobs == jobs)
        #expect(viewModel.state == .success)
        #expect(repo.requestedPages.count == 1)
        #expect(repo.requestedPages.first?.offset == 0)
    }
    
    @Test func getJobsDoesNotFetchAgainIfAlreadySuccessAndNotForced() async throws {
        let jobs = [makeJob(id: "1")]
        let repo = MockJobRepo(
            getJobsResponses: [
                JobPage(jobs: jobs, offset: 0, limit: 20, totalCount: 1)
            ],
            searchResponse: []
        )
        let viewModel = JobListViewModel(jobListRepo: repo)

        await viewModel.getJobs()
        #expect(repo.requestedPages.count == 1)

        await viewModel.getJobs(force: false)
        #expect(repo.requestedPages.count == 1)
    }
    
    @Test func getJobsFetchesAgainIfAlreadySuccessAndForced() async throws {
        let jobs = [makeJob(id: "1")]
        let repo = MockJobRepo(
            getJobsResponses: [
                JobPage(jobs: jobs, offset: 0, limit: 20, totalCount: 1),
                JobPage(jobs: jobs, offset: 0, limit: 20, totalCount: 1)
            ],
            searchResponse: []
        )
        let viewModel = JobListViewModel(jobListRepo: repo)

        await viewModel.getJobs()
        #expect(repo.requestedPages.count == 1)

        await viewModel.getJobs(force: true)
        #expect(repo.requestedPages.count == 2) // Should increment
    }


    @Test func getJobsHandlesNetworkErrors() async throws {
        let repo = MockJobRepo(getJobsResponses: [], searchResponse: [], errorToThrow: .invalidResponse)
        let viewModel = JobListViewModel(jobListRepo: repo)
        
        await viewModel.getJobs()
        #expect(viewModel.state == .failure(NetworkError.invalidResponse.userFriendlyMessage))
        #expect(viewModel.jobs.isEmpty)
    }


    @Test func searchJobsReplacesLoadedJobsAndRestoresOnEmptyQuery() async throws {
        let initialJobs = [makeJob(id: "1"), makeJob(id: "2")]
        let searchJobs = [makeJob(id: "99", title: "Search Result")]
        let repo = MockJobRepo(
            getJobsResponses: [
                JobPage(jobs: initialJobs, offset: 0, limit: 20, totalCount: 2)
            ],
            searchResponse: searchJobs
        )
        let viewModel = JobListViewModel(jobListRepo: repo)

        await viewModel.getJobs()
        viewModel.searchText = "swift"
        await viewModel.searchJobs()

        #expect(viewModel.jobs == searchJobs)
        #expect(viewModel.state == .success)
        #expect(repo.searchQueries == ["swift"])

        viewModel.searchText = ""
        await viewModel.searchJobs()

        #expect(viewModel.jobs == initialJobs)
        #expect(viewModel.state == .success)
    }

    @Test func loadNextPageAppendsResultsWhenLastRowAppears() async throws {
        let firstPageJobs = [makeJob(id: "1"), makeJob(id: "2")]
        let secondPageJobs = [makeJob(id: "3"), makeJob(id: "4")]
        let repo = MockJobRepo(
            getJobsResponses: [
                JobPage(jobs: firstPageJobs, offset: 0, limit: 2, totalCount: 4),
                JobPage(jobs: secondPageJobs, offset: 2, limit: 2, totalCount: 4)
            ],
            searchResponse: []
        )
        let viewModel = JobListViewModel(jobListRepo: repo)

        await viewModel.getJobs()
        #expect(viewModel.jobs == firstPageJobs)

        await viewModel.loadNextPageIfNeeded(currentJob: firstPageJobs.last!)

        #expect(viewModel.jobs == firstPageJobs + secondPageJobs)
        #expect(repo.requestedPages.count == 2)
        #expect(repo.requestedPages.last?.offset == 2)
    }
    
    @Test
    func test_loadNext_Page_Return_SearchTextThere() async {
        let firstPageJobs = [makeJob(id: "1"), makeJob(id: "2")]
        let secondPageJobs = [makeJob(id: "3"), makeJob(id: "4")]
        let repo = MockJobRepo(
            getJobsResponses: [
                JobPage(jobs: firstPageJobs, offset: 0, limit: 2, totalCount: 4),
                JobPage(jobs: secondPageJobs, offset: 2, limit: 2, totalCount: 4)
            ],
            searchResponse: []
        )
        let viewModel = JobListViewModel(jobListRepo: repo)

        await viewModel.getJobs()
        #expect(viewModel.jobs == firstPageJobs)
        viewModel.searchText = "SOMETHING"
        await viewModel.loadNextPageIfNeeded(currentJob: firstPageJobs.last!)

        #expect(viewModel.jobs == firstPageJobs)
        #expect(repo.requestedPages.count == 1)
        #expect(repo.requestedPages.last?.offset == 0)

    }
    
    @Test func loadNextPageExitsEarlyIfJobsEmpty() async throws {
        let repo = MockJobRepo(getJobsResponses: [], searchResponse: [])
        let viewModel = JobListViewModel(jobListRepo: repo)

        // Attempting to trigger load when empty
        await viewModel.loadNextPageIfNeeded(currentJob: makeJob(id: "1"))
        #expect(repo.requestedPages.isEmpty)
    }
    
    @Test func loadNextPageExitsWhenNoMorePages() async throws {
        let firstPageJobs = [makeJob(id: "1"), makeJob(id: "2")]
        let repo = MockJobRepo(
            getJobsResponses: [
                JobPage(jobs: firstPageJobs, offset: 0, limit: 2, totalCount: 2)
            ],
            searchResponse: []
        )
        let viewModel = JobListViewModel(jobListRepo: repo)
        await viewModel.getJobs()

        await viewModel.loadNextPageIfNeeded(currentJob: firstPageJobs.last!)
        #expect(repo.requestedPages.count == 1)
    }
    
    //Searching
    @Test
    func testSearchDebouncesRapidTyping() async throws {
        let initialJobs = [makeJob(id: "1"), makeJob(id: "2")]
        let searchJobs = [makeJob(id: "99", title: "Search Result")]
        let repo = MockJobRepo(
            getJobsResponses: [
                JobPage(jobs: initialJobs, offset: 0, limit: 20, totalCount: 2)
            ],
            searchResponse: searchJobs
        )
        let viewModel = JobListViewModel(jobListRepo: repo)
        await viewModel.getJobs()
        
        let typings = ["s", "se", "sea", "swift"]
        
        var tasks: [Task<Void, Never>] = []
        for query in typings {
            viewModel.searchText = query
            let task = Task {
                await viewModel.searchJobs()
            }
            tasks.append(task)
        }
        
        for task in tasks {
            _ = await task.result
        }

        #expect(repo.searchQueries == ["swift"])
        #expect(viewModel.jobs == searchJobs)
        #expect(viewModel.state == .success)

        viewModel.searchText = ""
        await viewModel.searchJobs()

        #expect(viewModel.jobs == initialJobs)
        #expect(viewModel.state == .success)
    }
    
    
    @Test
    func test_error_thrown_while_fetching_jobs() async throws {
        let page = [makeJob(id: "1"), makeJob(id: "2")]
        let repo = MockJobRepo(getJobsResponses:  [JobPage(jobs: page, offset: 0, limit: 2, totalCount: 4)], searchResponse: [], errorToThrow: .invalidResponse)
        let viewModel = JobListViewModel(jobListRepo: repo)
        
        await viewModel.getJobs()
        #expect(viewModel.state == .failure(repo.errorToThrow?.userFriendlyMessage ?? ""))
        #expect(viewModel.jobs.count == 0)
    }
}

private final class MockJobRepo: JobRepoType {
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

private func makeJob(id: String, title: String = "Job ") -> Job {
    Job(
        guid: id,
        title: title,
        companyName: "Company \(id)",
        companyLogo: nil,
        location: "Remote",
        employmentType: "Full-time",
        salaryRange: "$100k-$120k",
        category: "Engineering",
        description: "<p>Description</p>",
        applicationLink: "https://example.com",
        createdAt: Date(timeIntervalSince1970: 1_700_000_000),
        expiryDate: Date(timeIntervalSince1970: 1_700_086_400),
        jobRestrictions: ["Remote"]
    )
}

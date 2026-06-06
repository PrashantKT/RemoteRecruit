
//  JobDetailsViewModelTests.swift
//  RemoteRecruitUITests
//
//  Created by Prashant Tukadiya on 05/06/26.
//

import Foundation
import Testing
@testable import RemoteRecruit

@Suite("JobDetailsViewModel Tests")
struct JobDetailsViewModelTests {

    @Test("Hero Subtitle joins company name and location correctly")
    func heroSubtitleFormatting() {
        let job = makeTestJob(companyName: "Acme Corp", location: "Remote, US")
        let viewModel = JobDetailsViewModel(job: job)

        #expect(viewModel.heroSubtitle == "Acme Corp · Remote, US")
    }

    @Test("Date formatting")
    func createdDateTextFormatting() {
        let referenceDate = Date(timeIntervalSince1970: 1_700_000_000)
        let job = makeTestJob(createdAt: referenceDate)
        let viewModel = JobDetailsViewModel(job: job)

        let expectedDateText = referenceDate.formatted(date: .abbreviated, time: .omitted)
        #expect(viewModel.createdDateText == expectedDateText)
    }

    @Test("Company Summary")
    func companySummaryWithEmploymentType() {
        let job = makeTestJob(companyName: "Stark Tech", location: "New York", employmentType: "Contract")
        let viewModel = JobDetailsViewModel(job: job)

        #expect(viewModel.companySummary == "Stark Tech is hiring for a Contract role based in New York.")
    }

    @Test("Company Summary formatting falls back when employment type is nil")
    func companySummaryWithoutEmploymentType() {
        let job = makeTestJob(companyName: "Stark Tech", location: "New York", employmentType: nil)
        let viewModel = JobDetailsViewModel(job: job)

        #expect(viewModel.companySummary == "Stark Tech is hiring for a not specified role based in New York.")
    }

    @Test("Detail items properly construct location, salary, and employment type cards")
    func detailItemsPopulation() {
        let job = makeTestJob(
            location: "London",
            employmentType: "Part-time",
            salaryRange: "£40k - £50k"
        )
        let viewModel = JobDetailsViewModel(job: job)

        let items = viewModel.detailItems
        #expect(items.count == 3)

        // Location item
        #expect(items[0].id == "location")
        #expect(items[0].value == "London")

        // Salary item
        #expect(items[1].id == "salary")
        #expect(items[1].value == "£40k - £50k")

        // Employment type item
        #expect(items[2].id == "type")
        #expect(items[2].value == "Part-time")
    }

    @Test("Not disclosed salary")
    func detailItemsMissingValuesFallback() {
        let job = makeTestJob(employmentType: nil, salaryRange: nil)
        let viewModel = JobDetailsViewModel(job: job)

        let items = viewModel.detailItems
        #expect(items[1].value == "Not disclosed") // Salary
        #expect(items[2].value == "Not disclosed") // Type
    }

    @Test("Location tags")
    func locationTagsSanitization() {
        let job = makeTestJob(jobRestrictions: ["USA", "   ", "  Canada  ", "", "Germany"])
        let viewModel = JobDetailsViewModel(job: job)

        #expect(viewModel.locationTags == ["USA", "  Canada  ", "Germany"])
    }

    @Test("Application URL falls")
    func applicationURLValidationAndFallbacks() {
        // Valid URL
        let validJob = makeTestJob(applicationLink: "https://apple.com/careers")
        #expect(JobDetailsViewModel(job: validJob).applicationURL == URL(string: "https://apple.com/careers")!)

        // Empty Link
        let emptyJob = makeTestJob(applicationLink: "")
        #expect(JobDetailsViewModel(job: emptyJob).applicationURL == URL(string: "https://himalayas.app")!)

        // Whitespace Link
        let whitespaceJob = makeTestJob(applicationLink: "   ")
        #expect(JobDetailsViewModel(job: whitespaceJob).applicationURL == URL(string: "https://himalayas.app")!)
    }

    @Test("Company Logo URL test")
    func companyLogoURLValidation() {
        // Valid URL
        let jobWithLogo = makeTestJob(companyLogo: "https://example.com/logo.png")
        #expect(JobDetailsViewModel(job: jobWithLogo).companyLogoURL == URL(string: "https://example.com/logo.png"))

        // Nil Logo
        let jobNoLogo = makeTestJob(companyLogo: nil)
        #expect(JobDetailsViewModel(job: jobNoLogo).companyLogoURL == nil)

        // Empty Logo
        let jobEmptyLogo = makeTestJob(companyLogo: "")
        #expect(JobDetailsViewModel(job: jobEmptyLogo).companyLogoURL == nil)

        // Whitespace Logo
        let jobWhitespaceLogo = makeTestJob(companyLogo: "    ")
        #expect(JobDetailsViewModel(job: jobWhitespaceLogo).companyLogoURL == nil)
    }

    @Test("Company Initials")
    func companyInitialsParsing() {
        // Single word
        #expect(JobDetailsViewModel(job: makeTestJob(companyName: "Apple")).companyInitials == "A")

        // Multiple words
        #expect(JobDetailsViewModel(job: makeTestJob(companyName: "Google LLC")).companyInitials == "GL")

        // lowercase strings formatted to uppercase
        #expect(JobDetailsViewModel(job: makeTestJob(companyName: "swift developers corp")).companyInitials == "SD")

        // Empty name fallback handles smoothly
        #expect(JobDetailsViewModel(job: makeTestJob(companyName: "")).companyInitials == "")
    }

    // MARK: - Helpers

    private func makeTestJob(
        companyName: String = "Test Company",
        companyLogo: String? = nil,
        location: String = "Remote",
        employmentType: String? = "Full-time",
        salaryRange: String? = "$100,000",
        applicationLink: String = "https://example.com",
        createdAt: Date = Date(),
        jobRestrictions: [String] = []
    ) -> Job {
        Job(
            guid: UUID().uuidString,
            title: "Software Engineer",
            companyName: companyName,
            companyLogo: companyLogo,
            location: location,
            employmentType: employmentType,
            salaryRange: salaryRange,
            category: "Engineering",
            description: "<p>Work description</p>",
            applicationLink: applicationLink,
            createdAt: createdAt,
            expiryDate: createdAt.addingTimeInterval(86400),
            jobRestrictions: jobRestrictions
        )
    }
}

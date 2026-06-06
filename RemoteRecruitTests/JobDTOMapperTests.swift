
import Foundation
import Testing
@testable import RemoteRecruit

struct JobDTOMapperTests {
    @Test func salaryRangeIsFormattedWithoutTrailingDecimals() {
        let dto = JobDTO(
            guid: "1",
            title: "Operations Generalist",
            companyName: "Storyteller",
            companyLogo: nil,
            employmentType: "Full Time",
            minSalary: 500000,
            maxSalary: 550000,
            currency: "INR",
            categories: ["Operations"],
            locationRestrictions: ["South Africa"],
            description: "<p>Role</p>",
            applicationLink: "https://example.com",
            pubDate: Date(timeIntervalSince1970: 1_700_000_000),
            expiryDate: Date(timeIntervalSince1970: 1_700_086_400)
        )

        let job = dto.toDomain()

        #expect(job.salaryRange == "INR 500,000 - 550,000")
    }

    @Test func salaryRangeCollapsesToSingleAmountWhenMinAndMaxMatch() {
        let dto = JobDTO(
            guid: "2",
            title: "Operations Generalist",
            companyName: "Storyteller",
            companyLogo: nil,
            employmentType: "Full Time",
            minSalary: 250000,
            maxSalary: 250000,
            currency: "INR",
            categories: ["Operations"],
            locationRestrictions: ["South Africa"],
            description: "<p>Role</p>",
            applicationLink: "https://example.com",
            pubDate: Date(timeIntervalSince1970: 1_700_000_000),
            expiryDate: Date(timeIntervalSince1970: 1_700_086_400)
        )

        let job = dto.toDomain()

        #expect(job.salaryRange == "INR 250,000")
    }
}

//
//  JobDetailsViewModel.swift
//  RemoteRecruit
//
//  Created by OpenAI on 06/06/26.
//

import Foundation
import SwiftUI

struct JobDetailsViewModel {
    struct DetailItem: Identifiable, Hashable {
        let id: String
        let icon: String
        let title: String
        let value: String
        let tint: Color
    }

    let job: Job

    var heroSubtitle: String {
        [job.companyName, job.location].joined(separator: " · ")
    }

    var createdDateText: String {
        job.createdAt.formatted(date: .abbreviated, time: .omitted)
    }

    var companySummary: String {
        let employmentType = job.employmentType ?? "not specified"
        return "\(job.companyName) is hiring for a \(employmentType) role based in \(job.location)."
    }

    var detailItems: [DetailItem] {
        [
            DetailItem(
                id: "location",
                icon: "mappin.circle.fill",
                title: "Location",
                value: job.location,
                tint: AppTheme.locationRed
            ),
            DetailItem(
                id: "salary",
                icon: "banknote.fill",
                title: "Salary",
                value: job.salaryRange ?? "Not disclosed",
                tint: AppTheme.salaryGreen
            ),
            DetailItem(
                id: "type",
                icon: "clock.fill",
                title: "Type",
                value: job.employmentType ?? "Not disclosed",
                tint: AppTheme.accentBlue
            )
        ]
    }

    var locationTags: [String] {
        job.jobRestrictions.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }

    var applicationURL: URL {
        let trimmed = job.applicationLink.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty, let url = URL(string: trimmed) {
            return url
        }

        return URL(string: "https://himalayas.app")!
    }

    var companyLogoURL: URL? {
        guard
            let logo = job.companyLogo?.trimmingCharacters(in: .whitespacesAndNewlines),
            !logo.isEmpty,
            let url = URL(string: logo)
        else {
            return nil
        }
        return url
    }

    var companyInitials: String {
        let parts = job.companyName.split(separator: " ")
        let letters = parts.prefix(2).compactMap { $0.first }
        return String(letters).uppercased()
    }
}

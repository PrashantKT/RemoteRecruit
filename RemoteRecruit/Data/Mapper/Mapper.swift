//
//  Mapper.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 05/06/26.
//

import Foundation

extension JobDTO {
    func toDomain() -> Job {
        let salaryRange: String?

        if let minSalary, let maxSalary, let currency {
            salaryRange = Self.formatSalaryRange(
                currency: currency,
                minSalary: minSalary,
                maxSalary: maxSalary
            )
        } else {
            salaryRange = nil
        }

        return Job(
            guid: guid,
            title: title,
            companyName: companyName,
            companyLogo: companyLogo,
            location: locationRestrictions.first ?? "Remote",
            employmentType: employmentType,
            salaryRange: salaryRange,
            category: categories.first,
            description: description,
            applicationLink: applicationLink,
            createdAt: pubDate,
            expiryDate: expiryDate,
            jobRestrictions: locationRestrictions
        )
    }

    private static func formatSalaryRange(currency: String, minSalary: Double, maxSalary: Double) -> String {
        let formattedMin = formatWholeNumber(minSalary)
        let formattedMax = formatWholeNumber(maxSalary)

        if formattedMin == formattedMax {
            return "\(currency) \(formattedMin)"
        }

        return "\(currency) \(formattedMin) - \(formattedMax)"
    }

    private static func formatWholeNumber(_ value: Double) -> String {
        let integer = Int(value.rounded())
        let digits = String(integer)
        let isNegative = digits.hasPrefix("-")
        let rawDigits = isNegative ? String(digits.dropFirst()) : digits
        let reversedGroups = stride(from: 0, to: rawDigits.count, by: 3).map { index -> String in
            let start = rawDigits.index(rawDigits.endIndex, offsetBy: -min(index + 3, rawDigits.count))
            let end = rawDigits.index(rawDigits.endIndex, offsetBy: -index)
            return String(rawDigits[start..<end])
        }
        let grouped = reversedGroups.reversed().joined(separator: ",")
        return isNegative ? "-\(grouped)" : grouped
    }
}


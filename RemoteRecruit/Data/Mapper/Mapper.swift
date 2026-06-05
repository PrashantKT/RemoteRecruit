//
//  Mapper.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 05/06/26.
//


extension JobDTO {
    func toDomain() -> Job {

           let salaryRange: String?

           if let minSalary,let maxSalary, let currency {
               salaryRange = "\(currency) \(minSalary)-\(maxSalary)"
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
}


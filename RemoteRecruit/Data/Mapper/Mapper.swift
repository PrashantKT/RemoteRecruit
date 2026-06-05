//
//  Mapper.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 05/06/26.
//


extension JobDTO {
    func toDomain() -> Job {
           Job(
               guid: guid,
               title: title,
               companyName: companyName,
               companyLogo: companyLogo,
               location: locationRestrictions.first ?? "Remote",
               description: description,
               applicationLink: applicationLink
           )
       }
}

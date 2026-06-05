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

    init( jobListRepo: JobRepoType) {
        self.jobListRepo = jobListRepo
    }
 
    func getJobs() async  {
        do {
            jobs = try await jobListRepo.getJobs(page: .init(limit: 20, offset: 0)).jobs
        } catch {
            
            print("Something went wrong")
        }
        
    }
}

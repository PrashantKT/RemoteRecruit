//
//  JobListFactory.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 05/06/26.
//


struct JobListFactory {
    static func makeViewModel() -> JobListViewModel {
        JobListViewModel(jobListRepo: jobRepo)
    }
    
    private static var jobRepo: JobRepoType {
        return JobNetworkRepo(client: apiClient())
    }
    
    private static func apiClient() -> ApiClientType {
        ApiClient()
    }
    
    
    
}

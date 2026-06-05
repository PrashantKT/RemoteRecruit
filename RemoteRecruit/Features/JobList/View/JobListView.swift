//
//  JobListView.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 05/06/26.
//
import SwiftUI

struct JobListView: View {
    
   @State var vm: JobListViewModel = JobListFactory.makeViewModel()
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.jobs) { job in
                    VStack(alignment: .leading) {
                        Text(job.title)
                            .font(.headline)
                        Text(job.companyName)
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("Jobs")
        }
        .task {
            await vm.getJobs()
        }
        
    }
}

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
            Group {
                switch vm.state {
                case .idle: EmptyView()
                case .loading: ProgressView("Loading Please wait")
                case .empty:
                    ContentUnavailableView("No Jobs Available", systemImage: "building.2.crop.circle")
                case .success:
                    List {
                        ForEach(vm.jobs) { job in
                            NavigationLink {
                                JobDetailsView(job: job)
                            } label: {
                                
                                JobRowView(job: job)
                                    .task {
                                        await vm.loadNextPageIfNeeded(currentJob: job)
                                    }
                            }
                        }
                        if !vm.isLoadingNextPage {
                            VStack(spacing:12){
                                Image(systemName: "building.2.crop.circle")
                                    .font(.largeTitle)
                                    .symbolEffect(.breathe.pulse)
                                Text("Loading...")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                    }
                case .failure( let msg):
                    ErrorViewAction(title: "Oh no", message: msg, systemImage: "building.2.crop.circle") {
                        
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

#Preview {
    JobListView()
}

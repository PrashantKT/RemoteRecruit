//
//  JobListView.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 05/06/26.
//

import SwiftUI

struct JobListView: View {
    @State var vm: JobListViewModel = JobListFactory.makeViewModel()
    @Environment(NetworkMonitor.self) var monitor
    var body: some View {
        NavigationStack {
            Group {
                if !monitor.isConnected {
                    ErrorViewAction(title: "Network Error", message: "Please check your internet connection", systemImage: "wifi.slash") {
                        await vm.getJobs()
                    }
                } else {
                    content
                       
                }
                
            }
            .navigationTitle("Browse Jobs")
            .searchable(
                text: $vm.searchText,
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: "Job title or company"
            )
            .task(id: vm.searchText) {
                await vm.searchJobs()
            }
            .task {
                await vm.getJobs()
            }.refreshable {
                await vm.getJobs(force: true)
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        Group {
            switch vm.state {
            case .idle, .loading:
                LoadingView()
            case .empty:
                EmptyStateView(
                    title: vm.searchText.isEmpty ? "No Jobs Available" : "No Results",
                    message: vm.searchText.isEmpty
                    ? "Check back later for new opportunities."
                    : "No jobs match \"\(vm.searchText)\".\nTry a different search.",
                    systemImage: vm.searchText.isEmpty ? "briefcase.circle" : "magnifyingglass"
                )
            case .success:
                successContent
            case .failure(let msg):
                ErrorView(message: msg) {
                    await vm.getJobs(force: true)
                }
            }
        }.background {
            LinearGradient(
                colors: [AppTheme.backgroundStart, AppTheme.backgroundEnd],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }

    private var successContent: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 14) {
                ForEach(vm.jobs, id: \.id) { job in
                    NavigationLink {
                        JobDetailsView(job: job)
                    } label: {
                        JobRowView(job: job)
                            .task {
                                await vm.loadNextPageIfNeeded(currentJob: job)
                            }
                    }
                    .buttonStyle(.plain)
                }

                if vm.isLoadingNextPage {
                    HStack(spacing: 12) {
                        ProgressView()
                        Text("Loading more jobs")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 16)
        }
    }

}

#Preview {
    @Previewable @State  var monitor = NetworkMonitor()
    JobListView()
        .environment(monitor)
}

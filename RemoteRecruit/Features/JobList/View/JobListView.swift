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
            content
                .navigationTitle("Browse Jobs")
                .searchable(
                    text: $vm.searchText,
                    placement: .navigationBarDrawer(displayMode: .automatic),
                    prompt: "Job title or company"
                )
                
        }
        .task(id: vm.searchText) {
            await vm.searchJobs()
        }
        .task {
            await vm.getJobs()
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

    private var topHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Browse Jobs")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.primary)
                Text(vm.searchText.isEmpty
                     ? "Latest remote opportunities curated for you."
                     : "Showing results for \"\(vm.searchText)\"")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            HStack(spacing: 8) {
                Text("\(vm.jobs.count)")
                    .font(.headline.weight(.bold))
                Text(vm.jobs.count == 1 ? "opening" : "openings")
                    .font(.subheadline.weight(.medium))
                Spacer()
                if !vm.searchText.isEmpty {
                    Text("Search active")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(Capsule())
                }
            }
            .foregroundStyle(.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color(.separator).opacity(0.12), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}

#Preview {
    JobListView()
}

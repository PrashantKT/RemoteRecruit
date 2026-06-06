//
//  JobDetailsView.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 05/06/26.
//

import SwiftUI

struct JobDetailsView: View {
    private let viewModel: JobDetailsViewModel

    init(job: Job) {
        self.viewModel = JobDetailsViewModel(job: job)
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                JobDetailsHeroView(viewModel: viewModel)
                detailsRow
                    .padding(.horizontal, 16)

                contentCard(title: "About \(viewModel.job.companyName)") {
                    Text(viewModel.companySummary)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 16)


                contentCard(title: "Job Description") {
                    HTMLText(htmlString: viewModel.job.description)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .lineSpacing(6)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 16)

                if !viewModel.locationTags.isEmpty {
                    contentCard(title: "Location Tags") {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(viewModel.locationTags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(AppTheme.accentBlue)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(AppTheme.accentBlue.opacity(0.10))
                                        .clipShape(Capsule())
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(.bottom, 20)
        }
        .ignoresSafeArea(edges: .top)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            applyBar
        }
        .background {
            LinearGradient(
                colors: [AppTheme.backgroundStart, AppTheme.backgroundEnd],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }

    private var detailsRow: some View {
        HStack(spacing: 0) {
            ForEach(viewModel.detailItems.indices, id: \.self) { index in
                detailCard(viewModel.detailItems[index])

                if index < viewModel.detailItems.count - 1 {
                    divider
                }
            }
        }
        .padding(.vertical, 14)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(AppTheme.subtleBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 4)
    }

    private var applyBar: some View {
        VStack(spacing: 0) {
            Divider()

            VStack(spacing: 10) {
                Link(destination: viewModel.applicationURL) {
                    Label("Apply on Platform", systemImage: "arrow.up.right.square")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(AppTheme.accentBlue, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .shadow(color: AppTheme.accentBlue.opacity(0.28), radius: 10, x: 0, y: 4)
                }

            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)
            .background(.ultraThinMaterial)
        }
    }

    private func detailCard(_ item: JobDetailsViewModel.DetailItem) -> some View {
        VStack(spacing: 6) {
            Image(systemName: item.icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(item.tint)

            Text(item.title.uppercased())
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
                .tracking(0.6)

            Text(item.value)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
    }

    private func contentCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline.weight(.semibold))
                .foregroundStyle(.primary)

            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(AppTheme.subtleBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 4)
    }

    private var divider: some View {
        Rectangle()
            .fill(AppTheme.subtleBorder)
            .frame(width: 1, height: 54)
    }
}

#Preview {
    NavigationStack {
        JobDetailsView(job: .preview)
    }
}

//
//  JobRowView.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 05/06/26.
//

import SwiftUI

struct JobRowView: View {
    let job: Job

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            companyBadge

            VStack(alignment: .leading, spacing: 10) {
                headerRow
                Text(job.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                metaRow

                if let salaryRange = job.salaryRange, !salaryRange.isEmpty {
                    salaryPill(text: salaryRange)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(AppTheme.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(AppTheme.subtleBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 14, x: 0, y: 6)
    }

    private var companyBadge: some View {
        ZStack {
            if let logo = job.companyLogo, let url = URL(string: logo), !logo.isEmpty {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        fallbackBadge
                    }
                }
            } else {
                fallbackBadge
            }
        }
        .frame(width: 56, height: 56)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var fallbackBadge: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(AppTheme.avatarGradient(for: job.companyName))
            .overlay(
                Text(initials)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
            )
    }

    private var headerRow: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(job.companyName)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .lineLimit(1)

            Spacer(minLength: 8)

            if let employmentType = job.employmentType, !employmentType.isEmpty {
                employmentBadge(text: employmentType)
            }
        }
    }

    private var metaRow: some View {
        HStack(spacing: 10) {
            Label(job.location, systemImage: "mappin.circle.fill")
                .labelStyle(JobInfoLabelStyle(tint: AppTheme.locationRed))
            Spacer(minLength: 0)
            Text(job.createdAt.formatted(date: .abbreviated, time: .omitted))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .font(.caption)
    }

    private var initials: String {
        let parts = job.companyName.split(separator: " ")
        let letters = parts.prefix(2).compactMap { $0.first }
        return String(letters).uppercased()
    }

    private func employmentBadge(text: String) -> some View {
        let color = AppTheme.employmentColor(text)
        return Text(text)
            .font(.caption2.weight(.semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(color.opacity(0.12))
            .clipShape(Capsule())
    }

    private func salaryPill(text: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: "banknote.fill")
                .font(.caption2.weight(.semibold))
            Text(text)
                .font(.caption.weight(.semibold))
        }
        .foregroundStyle(AppTheme.salaryGreen)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(AppTheme.salaryGreen.opacity(0.10))
        .clipShape(Capsule())
    }
}

private struct JobInfoLabelStyle: LabelStyle {
    let tint: Color

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 4) {
            configuration.icon
                .foregroundStyle(tint)
            configuration.title
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    JobRowView(job: Job.preview)
        .padding()
        .background(AppTheme.backgroundStart)
}

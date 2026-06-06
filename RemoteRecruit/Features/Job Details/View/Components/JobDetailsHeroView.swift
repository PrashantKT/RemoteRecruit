//
//  JobDetailsHeroView.swift
//  RemoteRecruit
//
//  Created by OpenAI on 06/06/26.
//

import SwiftUI

struct JobDetailsHeroView: View {
    let viewModel: JobDetailsViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [AppTheme.accentBlue, AppTheme.accentPurple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(alignment: .leading, spacing: 18) {
                companyBadge
                    .frame(maxWidth: .infinity,alignment: .center)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(viewModel.job.title)
                        .font(.system(size: 27, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)

                    Text(viewModel.heroSubtitle)
                        .font(.system(size: 17, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.88))
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack {
                        HStack(spacing: 8) {
                            Image(systemName: "calendar")
                                .font(.caption.weight(.semibold))
                            Text(viewModel.createdDateText)
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white.opacity(0.84))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(.white.opacity(0.12), in: Capsule())
                        
                        Spacer()
                        if let employmentType = viewModel.job.employmentType, !employmentType.isEmpty {
                            employmentBadge(text: employmentType)
                                .frame(maxWidth: .infinity,alignment: .trailing)
                        }
                    }
                }
            }
            .padding(20)
            .padding(.top,50)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 310)
        .shadow(color: .black.opacity(0.16), radius: 18, x: 0, y: 12)
    }

    private func employmentBadge(text: String) -> some View {
        let tint = AppTheme.employmentColor(text)

        return Text(text)
            .font(.caption.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(tint.opacity(0.95), in: Capsule())
    }

    private var companyBadge: some View {
        AsyncImage(url: viewModel.companyLogoURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            default:
                fallbackBadge
            }
        }
        .frame(width: 68, height: 68)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(.white.opacity(0.16), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.18), radius: 10, x: 0, y: 6)
        .accessibilityHidden(true)
    }

    private var fallbackBadge: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(.white.opacity(0.16))
            .overlay(
                Text(viewModel.companyInitials)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.white)
            )
    }
}

#Preview {
    JobDetailsHeroView(viewModel: .init(job: .preview))
        .fixedSize(horizontal: false, vertical: true)
}

//
//  LoadingEmptyErrorViews.swift
//  RemoteRecruit
//
//  Created by OpenAI on 06/06/26.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 14) {
            ProgressView()
                .scaleEffect(1.1)

            Text("Loading jobs")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [AppTheme.backgroundStart, AppTheme.backgroundEnd],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

struct EmptyStateView: View {
    let title: String
    let message: String
    var systemImage: String = "briefcase.circle"

    @State private var appeared = false

    var body: some View {
        VStack(spacing: 22) {
            ZStack {
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(AppTheme.accentBlue.gradient.opacity(0.12))
                    .frame(width: 100, height: 100)

                Image(systemName: systemImage)
                    .font(.system(size: 42, weight: .light))
                    .foregroundStyle(AppTheme.accentBlue)
            }
            .scaleEffect(appeared ? 1 : 0.85)
            .opacity(appeared ? 1 : 0)

            VStack(spacing: 8) {
                Text(title)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 10)
            .padding(.horizontal, 28)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 30)
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.8).delay(0.05)) {
                appeared = true
            }
        }
    }
}

struct ErrorView: View {
    let message: String
    let retryAction: () async -> Void

    @State private var appeared = false

    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(Color.orange.opacity(0.12))
                    .frame(width: 120, height: 120)
                Image(systemName: "wifi.slash")
                    .symbolEffect(.breathe, value: appeared)
                    .font(.system(size: 42, weight: .light))
                    .foregroundStyle(.orange)
                    .background {
                        RoundedRectangle(cornerRadius: 32,style: .continuous)
                            .fill(Color.orange.opacity(0.12))
                    }
            }
            .scaleEffect(appeared ? 1 : 0.85)
            .opacity(appeared ? 1 : 0)

            VStack(spacing: 8) {
                Text("Unable to Load Jobs")
                    .font(.title3.weight(.bold))
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 10)
            .padding(.horizontal, 30)

            Button {
                Task {
                    await retryAction()
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                    Text("Try Again")
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(minWidth: 150)
                .padding(.vertical, 14)
                .background(AppTheme.accentBlue.gradient, in: .capsule)
            }
            .opacity(appeared ? 1 : 0)
            .scaleEffect(appeared ? 1 : 0.95)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 48)
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.8).delay(0.05)) {
                appeared = true
            }
        }
    }
}

#Preview {
    EmptyStateView(
        title: "No Jobs Available" ,
        message:
             "Check back later for new opportunities."
            ,
        systemImage:  "briefcase.circle")
}


#Preview {
    ErrorView(message: "Something went wrong") {
        
    }
}

#Preview {
    ErrorView(message: "Something went wrong") {
        
    }
}

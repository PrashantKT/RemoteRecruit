//
//  JobDetailsView.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 05/06/26.
//

import SwiftUI

struct JobDetailsView: View {
    let job: Job
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 24) {
                headerHeroSection
                Divider()
                metadataTagSection
                Divider()
                descriptionSection
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
       
    }
    
    // MARK: - Components
    
    private var headerHeroSection: some View {
        HStack(alignment: .top, spacing: 16) {
            // Company Logo Placeholder / Remote Image Loading
            AsyncImage(url: URL(string: job.companyLogo ?? "")) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Circle()
                    .fill(Color.accentColor.opacity(0.1))
                    .overlay(
                        Image(systemName: "briefcase.fill")
                            .foregroundColor(.accentColor)
                    )
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(job.companyName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                Text(job.title)
                    .font(.title3)
                    .bold()
                    .lineLimit(3)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                VStack {
                    Text(job.createdAt.formatted(date: .complete, time: .omitted))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                   
                }
            }
        }
        .padding(.top, 8)
    }
    
    private var metadataTagSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Job Overview")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 12) {
                metadataCard(icon: "dollarsign.circle.fill", color: .green, title: "Compensation", value: job.salaryRange ?? "Not Disclosed")
                metadataCard(icon: "clock.fill", color: .orange, title: "Job Type", value: job.employmentType ?? "Not Disclosed")
                metadataCard(icon: "globe", color: .blue, title: "Location", value: job.jobRestrictions.joined(separator: ", "))

                
            }
        }
    }
    
  
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Role Description")
                .font(.headline)
            
            
            HTMLText(htmlString: job.description)
                .font(.body)
                .lineSpacing(6)
                .foregroundColor(.primary)
        }
    }
    
    private var applyButtonStickyBar: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                Link(destination: URL(string: job.applicationLink) ?? URL(string: "https://himalayas.app")!) {
                    Text("Apply on Platform")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.accentColor)
                        .cornerRadius(12)
                        .shadow(color: Color.accentColor.opacity(0.3), radius: 8, x: 0, y: 4)
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 24)
            .background(.ultraThinMaterial)
        }
    }
    
    // MARK: - Sub-View Helpers
    private func metadataCard(icon: String, color: Color, title: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 32, height: 32)
                .background(color.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                Text(value)
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(10)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(10)
    }
}
#Preview {
    JobDetailsView(job: .preview)
}

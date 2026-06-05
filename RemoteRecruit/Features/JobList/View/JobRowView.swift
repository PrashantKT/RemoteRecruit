//
//  JobListView.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 05/06/26.
//

import SwiftUI

struct JobRowView: View {
    let job: Job
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                
                AsyncImage(url: URL(string: job.companyLogo ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "building.2.crop.circle")
                                .font(.system(size: 30))
                                .foregroundColor(Color.gray.opacity(0.7))
                        )                }
                .frame(width: 60,height: 60)
                .clipShape(.circle)
                
               
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(job.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    Text(job.companyName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    VStack(alignment: .leading,spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.red)
                            Text(job.location)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        HStack(spacing: 4) {
                            Image(systemName: "dollarsign.circle.fill")
                                .foregroundColor(.green)
                            Text(job.salaryRange ?? "Not disclosed")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                   
                    HStack(spacing:4) {
                        Text("Published at :")
                        Text(job.createdAt.formatted(date: .abbreviated, time: .omitted))
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)

                }
               
                Spacer()
            }
            
           
        }
        
    }
    
  
}



struct JobRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            JobRowView(job: Job.preview)
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color(UIColor.systemGroupedBackground))
            
          
          
        }
    }
}

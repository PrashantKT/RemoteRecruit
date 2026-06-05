//
//  Job.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 05/06/26.
//

import Foundation

struct Job: Identifiable, Equatable {

    var id: String { guid }

    let guid: String

    let title: String
    let companyName: String
    let companyLogo: String?
    let location: String
    let employmentType: String?
    let salaryRange: String?
    let category: String?
    let description: String
    let applicationLink: String
    let createdAt: Date
    let expiryDate: Date
    let jobRestrictions: [String]
}

struct JobPage {
    let jobs: [Job]
    let offset: Int
    let limit: Int
    let totalCount: Int
}

extension Job {
    static let preview: Job = .init(
        guid: "1",
        title: "Job Title",
        companyName: "Company Name",
        companyLogo: nil,
        location: "Location",
        employmentType: "Full-time",
        salaryRange: "£30,000 - £40,000",
        category: "Category",
        description: "<p><strong style=\"font-family: inherit; font-size: 0.875rem;\">We are sharing a specialised part-time consulting opportunity for U.S.-based legal professionals experienced in arbitration, dispute resolution, commercial disputes, legal analysis, and structured case review.</strong></p><p>This role supports current and upcoming remote consulting opportunities focused on structured arbitration review, dispute analysis, legal reasoning assessment, case documentation, and high-quality project execution. Selected professionals will apply their arbitration expertise to review realistic dispute scenarios, evaluate legal materials, prepare structured written outputs, and support accurate, evidence-based dispute resolution workflows.</p><h3>Key Responsibilities</h3><h3>Professionals in this role may contribute to:</h3><h3>Arbitration Case Review &amp; Dispute Analysis</h3><ul><li>Review arbitration scenarios      involving commercial disputes, contractual claims, procedural issues,      hearing materials, and case documentation</li><li>Evaluate dispute materials      against source records, procedural requirements, applicable rules, and      defined review criteria</li><li>Support structured review of      arbitration submissions, pleadings, witness statements, exhibits,      procedural orders, and award-related materials</li><li>Identify missing information,      legal reasoning gaps, procedural issues, and expected arbitration review      outcomes</li></ul><h3>Legal Reasoning &amp; Written Assessment</h3><ul><li>Prepare clear written analysis      of arbitration-related issues based on case facts, governing rules,      contract terms, and supporting materials</li><li>Evaluate legal arguments,      factual summaries, procedural positions, and dispute resolution strategies</li><li>Support structured review of      legal memos, case summaries, issue lists, hearing preparation materials,      and settlement-related documentation</li><li>Provide well-organized written      feedback with strong legal reasoning and professional judgment</li></ul><h3>Dispute Resolution Workflow Support</h3><ul><li>Review arbitration and dispute      resolution workflows involving case timelines, document organization,      procedural milestones, and matter strategy</li><li>Support structured evaluation      of materials connected to domestic arbitration, commercial arbitration,      employment arbitration, construction arbitration, international      arbitration, or related dispute forums</li><li>Translate arbitration      experience into clear task documentation, review criteria, and structured      written outputs</li><li>Maintain accuracy, consistency,      and professional judgment across submitted work</li></ul><h3>Ideal Profile</h3><h3>Strong candidates may have:</h3><ul><li>10+ years of legal practice      experience with a strong focus on arbitration or dispute resolution</li><li>Experience as an arbitration      attorney, disputes counsel, litigation attorney, commercial disputes      lawyer, in-house disputes counsel, or arbitration-focused legal advisor</li><li>Strong background in reviewing      case materials, assessing legal arguments, preparing written analysis, and      managing complex dispute workflows</li><li>Familiarity with arbitration      rules, procedural orders, hearing preparation, evidentiary materials, and      award-related documentation</li><li>Strong written communication      skills and ability to explain legal reasoning clearly</li><li>Ability to follow structured      instructions and produce evidence-based legal work</li></ul><h3>Educational Background</h3><ul><li>Juris Doctor degree is strongly      preferred</li><li>Active U.S. bar admission or      equivalent legal qualification is highly relevant</li><li>Equivalent practical experience      in arbitration, litigation, commercial disputes, or dispute resolution may      also be relevant depending on role scope</li></ul><h3>Nice to Have</h3><ul><li>Experience with AAA, JAMS,      ICDR, FINRA, ICC, LCIA, CPR, or other arbitration forums</li><li>Background in commercial      arbitration, employment arbitration, construction disputes, securities      arbitration, international arbitration, or complex civil disputes</li><li>Experience preparing or      reviewing arbitration demands, responses, briefs, witness statements,      exhibits, hearing bundles, procedural orders, or draft awards</li><li>Experience as counsel in      arbitration proceedings, arbitrator support, mediation, settlement      negotiations, or dispute strategy</li><li>Strong attention to detail in      case-file-heavy, procedure-focused, and writing-intensive legal      environments</li></ul><h3>Why This Opportunity</h3><ul><li>Apply arbitration and dispute      resolution expertise to structured remote project work</li><li>Contribute to high-quality      legal analysis, arbitration review, and dispute workflow assessment</li><li>Work on flexible assignments      aligned with your legal background</li><li>Use your arbitration judgment      in a focused, detail-oriented review environment</li><li>Remote structure with      competitive hourly compensation</li></ul><h3>Contract Details</h3><ul><li>Independent      contractor role</li><li>Fully      remote with flexible scheduling</li><li>Part-time commitment depending      on project availability</li><li>Competitive rates between <strong>$115–$135      per hour</strong> depending on expertise</li><li>Weekly payments via Stripe or      Wise</li><li>Projects may be extended,      shortened, or adjusted depending on scope and performance</li><li>Work will not involve access to      confidential or proprietary information from any employer, client, or      institution</li></ul><h3>About the Platform</h3><p>This opportunity is available through <a href=\"https://himalayas.app/companies/24-mag\">24-MAG</a> LLC. We connect experienced professionals with remote consulting opportunities across technical, evaluation, and project-based workstreams.</p><p>By submitting this application, you acknowledge that your information may be processed by <a href=\"https://himalayas.app/companies/24-mag\">24-MAG</a> LLC for recruitment and opportunity matching in accordance with our Privacy Policy: <a href=\"https://www.24-mag.com/privacy-policy\" rel=\"nofollow ugc noopener noreferrer\" target=\"_blank\">https://www.24-mag.com/privacy-policy</a>.</p><p>Originally posted on <a href=\"https://himalayas.app\">Himalayas</a></p>",
        applicationLink: "",createdAt: .now ,
        expiryDate: .now.addingTimeInterval(TimeInterval.random(in: 100...1500))
        ,jobRestrictions: ["USA", "Canada"])
}

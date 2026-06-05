//
//  UIkit+webview.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 05/06/26.
//

import SwiftUI
import WebKit

struct HTMLText: View {
    
    let htmlString: String
    
    var body: some View {
        if let attributedString = try? AttributedString(htmlData: Data(htmlString.utf8)) {
            Text(attributedString) // Displays styled text natively
        } else {
            Text(htmlString) // Fallback to raw text if parsing fails
        }
    }
}

// Helper extension to keep your views clean
extension AttributedString {
    init(htmlData: Data) throws {
        let nsAttributedString = try NSAttributedString(
            data: htmlData,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        )
        self.init(nsAttributedString)
    }
}

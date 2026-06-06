//
//  SteachHeader.swift
//  RemoteRecruit
//
//  Created by Prashant Tukadiya on 06/06/26.
//

import SwiftUI

struct StretchableHeader: ViewModifier {
    
    func body(content: Content) -> some View {
        
        content
            .visualEffect { effect, proxy in
                let currentHeight = proxy.size.height
                let yPos = proxy.frame(in: .scrollView).minY
                
                let newHeight = currentHeight + max(0, yPos)
                let scale = newHeight / currentHeight
                
                return effect
                    .scaleEffect(x: scale, y: scale, anchor: .bottom)
            }
        
    }
}

extension View {
    func stretchableHeader() -> some View {
        modifier(StretchableHeader())
    }
}

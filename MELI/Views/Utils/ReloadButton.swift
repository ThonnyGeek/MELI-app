//
//  ReloadButton.swift
//  MELI
//
//  Created by Thony Gonzalez on 1/03/24.
//

import SwiftUI

struct ReloadButton: View {
    
    let onTapAction: () -> Void
    
    var body: some View {
        
        let screenSize: CGRect = (UIScreen.current?.bounds ?? UIScreen.main.bounds)
        
        Button {
            onTapAction()
        } label: {
            HStack {
                Image(systemName: "arrow.triangle.2.circlepath.circle")
                
                Text("Recargar")
            }
        }
        .buttonStyle(MELIMainButtonStyle())
        .frame(width: screenSize.width * 0.4)
    }
}

#Preview {
    ReloadButton {
        
    }
}

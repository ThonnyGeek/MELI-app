//
//  SearchBarView.swift
//  MELI
//
//  Created by Thony Gonzalez on 28/02/24.
//

import SwiftUI

struct SearchBarView: View {
    
    @AppStorage("site_id") var siteIdAppStorage: String?
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.mainYellow, .myPrimary], startPoint: .top, endPoint: .center)
                .ignoresSafeArea()
            
            Text("siteIdAppStorage: \(siteIdAppStorage ?? "")")
        }
    }
}

#Preview {
    SearchBarView()
}

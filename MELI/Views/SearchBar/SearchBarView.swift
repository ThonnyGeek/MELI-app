//
//  SearchBarView.swift
//  MELI
//
//  Created by Thony Gonzalez on 28/02/24.
//

import SwiftUI

struct SearchBarView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [.mainYellow, .myPrimary, .myPrimary], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    SearchBarView()
}

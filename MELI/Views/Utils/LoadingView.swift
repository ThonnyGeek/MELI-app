//
//  LoadingView.swift
//  MELI
//
//  Created by Thony Gonzalez on 29/02/24.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    
    let style: UIBlurEffect.Style
    
    var removeAllFilters: Bool = false
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        view.alpha = 0.96
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        DispatchQueue.main.async {
            if let backdropLayer = uiView.layer.sublayers?.first {
                if removeAllFilters {
                    backdropLayer.filters = []
                } else {
                    backdropLayer.filters?.removeAll(where: { filter in
                        String(describing: filter) != "gaussianBlur"
                    })
                }
            }
        }
    }
}

struct LoadingView: View {
    
    var show: Bool
    
    var body: some View {
        ZStack {
            BlurView(style: .systemUltraThinMaterial)
                .ignoresSafeArea()
            
            ProgressView()
                .tint(.mainBlue)
                .controlSize(.large)
        }
        .opacity(show ? 1 : 0)
        .transition(.opacity)
        .animation(.easeInOut, value: show)
    }
}

#Preview {
    LoadingView(show: true)
}

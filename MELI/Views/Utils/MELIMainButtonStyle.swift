//
//  MELIMainButtonStyle.swift
//  MELI
//
//  Created by Thony Gonzalez on 1/03/24.
//

import SwiftUI

public struct MELIMainButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        MELIMainButtonStyleView(configuration: configuration)
    }
}

private extension MELIMainButtonStyle {
    struct MELIMainButtonStyleView: View {
        let configuration: MELIMainButtonStyle.Configuration

        var body: some View {
            return configuration.label
                .font(.manropeBold(16))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.mainBlue)
                }
                .padding(10)
                .opacity(configuration.isPressed ? 0.8 : 1.0)
                .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
        }
    }
}


struct MELIMainButtonStylePreview: View {
    var body: some View {
        Button("Main button") {
            //
        }
        .buttonStyle(MELIMainButtonStyle())
    }
}

#Preview {
    MELIMainButtonStylePreview()
}

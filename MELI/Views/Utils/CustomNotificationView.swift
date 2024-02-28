//
//  CustomNotificationView.swift
//  MELI
//
//  Created by Thony Gonzalez on 27/02/24.
//

import SwiftUI

struct CustomNotificationView: View {
    let text: LocalizedStringKey
    var subtitle: LocalizedStringKey?
    let theme: CNTheme
    
    var textColor: Color = .gray
    var icon: Image = Image(systemName: "checkmark.circle")

    init(text: LocalizedStringKey, subtitle: LocalizedStringKey? = nil, theme: CNTheme) {
        self.text = text
        self.subtitle = subtitle
        self.theme = theme
        switch self.theme {
        case .success:
            self.textColor = .green
            self.icon = Image(systemName: "checkmark.circle")
        case .error:
            self.textColor = .red
            self.icon = Image(systemName: "wrongwaysign")
            
        }
    }
    
    var body: some View {
        ZStack {
            HStack (spacing: 10) {
                
                icon
                    .resizable()
                    .scaledToFill()
                    .frame(width: 15, height: 15)
                
                VStack (alignment: .leading, spacing: 5) {
                    Text(text)
//                        .font(.poppinsMedium(14))
                        .font(.system(.caption))
                        .lineLimit(2)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
//                            .font(.poppinsMedium(12))
                            .lineLimit(3)
                    }
                }
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .foregroundColor(textColor)
            .background {
                ZStack {
                    
                    Color.white
                    textColor.opacity(0.4)
                }
            }
            .cornerRadius(8)
        }
        .frame(width: UIScreen.main.bounds.width)
        .frame(maxHeight: 100)
    }
}

struct CustomNotificationViewContainer: View {
    var body: some View {
        VStack {
            Text("s")
        }
    }
}

#Preview {
    CustomNotificationViewContainer()
    .environment(\.locale, .init(identifier: "es"))
}

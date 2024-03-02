//
//  InAppNotificationsView.swift
//  MELI
//
//  Created by Thony Gonzalez on 27/02/24.
//

import SwiftUI

struct InAppNotificationsView: View {
    
    @EnvironmentObject var viewModel: InAppNotificationsViewModel
    
    var body: some View {
        GeometryReader { geo in
            VStack (spacing: 5) {
                ForEach(viewModel.notifications.suffix(2)) { notification in
                    CustomNotificationView(text: LocalizedStringKey(notification.title), subtitle: LocalizedStringKey(notification.bodyText ?? ""), theme: notification.theme)
                        .gesture(DragGesture().onChanged { value in
                            if let last = viewModel.notifications.last, notification.id == last.id {
                                viewModel.dragGestureValueSecond = value.translation.height
                            } else {
                                viewModel.dragGestureValueFirst = value.translation.height
                            }
                        })
                        .transition(.offset(y: -(geo.safeAreaInsets.top * 3)))
                }
            }
            .frame(maxHeight: geo.size.height, alignment: .top)
        }
    }
}

struct PreviewView: View {
    
    @StateObject var viewModel: InAppNotificationsViewModel = InAppNotificationsViewModel()
    
    var body: some View {
        ZStack {
            
            Color.red.opacity(0.1).ignoresSafeArea()
            
            VStack {
                
                Button {
                    viewModel.showError("sdds", subtitle: "La solicitud ha tardado demasiado en completarse debido a problemas con el servidor de la APIClient.")
                } label: {
                    Text("88888d8d8d8d")
                        .foregroundStyle(.black)
                        .frame(width: 200, height: 50)
                        .border(.red)
                }
            }
        }
        .overlay {
            InAppNotificationsView()
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    PreviewView()
}

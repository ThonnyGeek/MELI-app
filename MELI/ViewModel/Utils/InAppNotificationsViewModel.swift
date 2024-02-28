//
//  InAppNotificationsViewModel.swift
//  MELI
//
//  Created by Thony Gonzalez on 27/02/24.
//

import SwiftUI
import Combine

final class InAppNotificationsViewModel: ObservableObject {
    
    //MARK: Variables
    
    @Published var notifications: [InAppNotificationModel] = [] {
        
        willSet {
            guard let ID = newValue.last?.id else {
                return
            }
            
            if newValue.count > 2 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
                    withAnimation {
                        self?.notifications.removeAll(where: { $0.id == ID })
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
                    withAnimation {
                        self?.notifications.removeAll(where: { $0.id == ID })
                    }
                }
            }
        }
    }
    
    @Published var dragGestureValueFirst: Double = 0.0
    @Published var dragGestureValueSecond: Double = 0.0
    
    private var subscriptions = Set<AnyCancellable>()
    
    //MARK: Constants
    
    //MARK: init
    init() {
        
        $dragGestureValueFirst
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink { [weak self] text in
                guard let self = self else {
                    return
                }
                
                if dragGestureValueFirst < 0 && !self.notifications.isEmpty {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        weak let _ = withAnimation {
                            self.notifications.remove(at: self.notifications.count - 2)
                        }
                    }
                }
            }
            .store(in: &subscriptions)
        
        $dragGestureValueSecond
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink { [weak self] text in
                guard let self = self else {
                    return
                }
                
                if dragGestureValueSecond < 0 && !self.notifications.isEmpty {
                    DispatchQueue.main.async { [weak self] in
                        weak let _ = withAnimation {
                            self?.notifications.removeLast()
                        }
                    }
                }
            }
            .store(in: &subscriptions)
    }
    
    func showSuccess(_ title: String, subtitle: String?) {
        
            DispatchQueue.main.async { [weak self] in
                withAnimation {
                self?.notifications.append(InAppNotificationModel(title: title, bodyText: subtitle, theme: .success))
            }
        }
    }
    
    func showError(_ title: String, subtitle: String?) {
        
        DispatchQueue.main.async { [weak self] in
            withAnimation {
                self?.notifications.append(InAppNotificationModel(title: title, bodyText: subtitle, theme: .error))
            }
        }
    }
}

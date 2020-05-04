//
//  GameController.swift
//  Life
//
//  Created by Work on 5/3/20.
//  Copyright © 2020 Isaac Ruiz. All rights reserved.
//

import Combine
import Cooridnator

class ActionHandler {
    
    private var timer: Timer?
    private var subscriptions: Set<AnyCancellable> = []
    
    init(_ updates: EventCoordinator<GameOfLifeEventHandler>.UpdatePublisher) {
        updates
            .receive(on: RunLoop.main)
            .sink { [weak self] action, state, notify in
                switch action {
                case .start:
                    self?.startTimer(notify: notify)
                case .stop:
                    self?.stopTimer()
                }
            }
            .store(in: &subscriptions)
    }
    
    private func startTimer(notify: EventCoordinator<GameOfLifeEventHandler>.EventPublisher) {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { _ in
            notify.send(.evolve)
        })
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

}

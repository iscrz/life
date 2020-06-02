//
//  SceneDelegate.swift
//  Life2
//
//  Created by Work on 5/5/20.
//  Copyright © 2020 Isaac Ruiz. All rights reserved.
//

import UIKit
import SwiftUI
import Cooridnator

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var lifeActionHandler: GameOfLifeAsyncActionHandler!
    var coordinator: EventCoordinator<GameOfLifeEventHandler>!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let state = GameOfLife.State(width: 30, height: 60)
        coordinator = EventCoordinator(GameOfLifeEventHandler(), state: state)
        lifeActionHandler = GameOfLifeAsyncActionHandler(coordinator!.updates)
        
        let viewModel = GameOfLifeViewModel(coordinator: coordinator)
        let contentView = GameOfLifeView(viewModel: viewModel)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}


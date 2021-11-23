//
//  AppDelegate.swift
//  PokemonLibrary
//
//  Created by Daniele Salvioni on 20/11/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainCoordinator: CoordinatorProtocol?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let mainVC = UINavigationController()
        self.mainCoordinator = PokemonCoordinator(rootController: mainVC)
        self.mainCoordinator?.start()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        self.window?.rootViewController = mainVC
        self.window?.makeKeyAndVisible()
        
        return true
    }
}


//
//  Resources.swift
//  PokemonLibrary
//
//  Created by Daniele Salvioni on 20/11/21.
//

import Foundation
import UIKit

enum Resources {
    enum Api {
        static let baseURL = URL(string: "https://pokeapi.co/api/v2/")!
    }
    enum UI {
        enum Appearance {
            static func navBar() {
                if #available(iOS 15.0, *) {
                    let navigationBarAppearance = UINavigationBarAppearance()
                    navigationBarAppearance.configureWithDefaultBackground()
                    UINavigationBar.appearance().standardAppearance = navigationBarAppearance
                    UINavigationBar.appearance().compactAppearance = navigationBarAppearance
                    UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
                }
            }
        }
    }
}

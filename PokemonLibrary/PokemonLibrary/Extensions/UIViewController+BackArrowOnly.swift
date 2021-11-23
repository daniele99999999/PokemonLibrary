//
//  UIViewController+BackArrowOnly.swift
//  PokemonLibrary
//
//  Created by Daniele Salvioni on 22/11/21.
//

import Foundation
import UIKit

extension UIViewController {
    func showBackArrowOnly() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

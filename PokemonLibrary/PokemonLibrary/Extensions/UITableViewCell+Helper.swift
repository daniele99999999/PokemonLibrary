//
//  UITableViewCell+Helper.swift
//  PokemonLibrary
//
//  Created by Daniele Salvioni on 21/11/21.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        "\(String(describing: self))-reuseIdentifier"
    }
}

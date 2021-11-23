//
//  CommonTypes.swift
//  PokemonLibrary
//
//  Created by Daniele Salvioni on 20/11/21.
//

import Foundation

public typealias VoidClosure = () -> Void
public typealias VoidInputClosure<O> = () -> O
public typealias VoidOutputClosure<I> = (I) -> Void
public typealias Closure<I, O> = (I) -> O

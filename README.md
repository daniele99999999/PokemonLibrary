
# # PokemonLibrary

## Description
This is a proposed solution for a CodeChallenge about building an app that shows a Pokemon list with its image and name. When a user taps on a Pokemon, the app will show a detailed view of Pokemon’s name, images, stats, and category (fire, smoke, etc).
The APIs are available at the following address: https://pokeapi.co

these are Guidelines & Requirements:
1. Swift 5.5
2. Target SDK iOS 11
3. less external libraries as possible, and with them use CocoaPods, Carthage, or SwiftPM
4. MVVM pattern
4. UI from code (no XIBs or Storyboards) and must be dynamic iPhone/iPad

there are Bonus Requirements:
1. working offline
5. Unit Tests
6. useful extra functionalities


## Architecture
The architecture implemented its built on MVVM + Coordinator.
Every screen Its built around a ViewModel and a ViewController, with all the UI managed by a custom UIView attacched to the root of UIViewController. The Coordinator is responbile for navigation between ViewControllers. The data provider its built following a Repository pattern that abstract persistence and network services.
Every component its built with protocols and dependency injection, for make every piece of logic more reliable and testable.
Because of lack of experience with reactive programming, the current implementation of MVVM it's built around closures, to mimic the behaivor of reactive frameworks. There are Unit Tests for viewmodels and services. The app it's currently fully usable offline (obviously showing itmes in the list that were previously opened in past executions). Pagination for the list its also implemented with infinite scrolling .

## Notes
The persistence service for lack of time, it's implemented using UserDefaults. Sure it's not ideal, but its built around a protocol, so it's easy to change the data layer in the future. Without any specific requirements, the repository its always fetching data from the persistence, and if not finding anything, fetching from the network.

## Requirements
Target SDK 11.4. 
Developed on Xcode 13.1

## Installation & Execution
There are no external dependencies, so open the project and run.

## Author

Danieleì

## Licenza

PokemonLibrary it's available under MIT License. See LICENSE file for more information

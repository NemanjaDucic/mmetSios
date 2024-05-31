//
//  NavigationMapSingleton.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 31.5.24..
//

import Foundation
import MapboxNavigationCore
import MapboxNavigationUIKit
@MainActor
class NavigationMapSingleton {
    static let shared = NavigationMapSingleton()

    let mapboxNavigationProvider = MapboxNavigationProvider(
          coreConfig: .init(
              locationSource: false ? .simulation(
                  initialLocation: nil
              ) : .live
          )
      )
    lazy var mapboxNavigation = mapboxNavigationProvider.mapboxNavigation

}

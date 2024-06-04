//
//  NavigationMapSingleton.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 31.5.24..
//

import Foundation
import MapboxNavigationCore
import MapboxNavigationUIKit
import CoreLocation
@MainActor
class NavigationMapSingleton {
    static let shared = NavigationMapSingleton()

    let mapboxNavigationProvider = MapboxNavigationProvider(
          coreConfig: .init(
              locationSource: false ? .simulation(
                  initialLocation: CLLocation(latitude: 44.2107675, longitude: 20.9224158)
              ) : .live
          )
           
      )
    lazy var mapboxNavigation = mapboxNavigationProvider.mapboxNavigation
}

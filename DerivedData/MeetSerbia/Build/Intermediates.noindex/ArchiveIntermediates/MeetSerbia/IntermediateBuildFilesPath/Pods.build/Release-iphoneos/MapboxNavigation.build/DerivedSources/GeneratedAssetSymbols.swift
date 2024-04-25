import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
extension ColorResource {

}

// MARK: - Image Symbols -

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
extension ImageResource {

    /// The "RailroadCrossingDay" asset catalog image resource.
    static let railroadCrossingDay = ImageResource(name: "RailroadCrossingDay", bundle: resourceBundle)

    /// The "RailroadCrossingNight" asset catalog image resource.
    static let railroadCrossingNight = ImageResource(name: "RailroadCrossingNight", bundle: resourceBundle)

    /// The "RouteInfoAnnotationLeftHanded" asset catalog image resource.
    static let routeInfoAnnotationLeftHanded = ImageResource(name: "RouteInfoAnnotationLeftHanded", bundle: resourceBundle)

    /// The "RouteInfoAnnotationRightHanded" asset catalog image resource.
    static let routeInfoAnnotationRightHanded = ImageResource(name: "RouteInfoAnnotationRightHanded", bundle: resourceBundle)

    /// The "StopSignDay" asset catalog image resource.
    static let stopSignDay = ImageResource(name: "StopSignDay", bundle: resourceBundle)

    /// The "StopSignNight" asset catalog image resource.
    static let stopSignNight = ImageResource(name: "StopSignNight", bundle: resourceBundle)

    /// The "TrafficSignalDay" asset catalog image resource.
    static let trafficSignalDay = ImageResource(name: "TrafficSignalDay", bundle: resourceBundle)

    /// The "TrafficSignalNight" asset catalog image resource.
    static let trafficSignalNight = ImageResource(name: "TrafficSignalNight", bundle: resourceBundle)

    /// The "YieldSignDay" asset catalog image resource.
    static let yieldSignDay = ImageResource(name: "YieldSignDay", bundle: resourceBundle)

    /// The "YieldSignNight" asset catalog image resource.
    static let yieldSignNight = ImageResource(name: "YieldSignNight", bundle: resourceBundle)

    /// The "back" asset catalog image resource.
    static let back = ImageResource(name: "back", bundle: resourceBundle)

    /// The "carplay_close" asset catalog image resource.
    static let carplayClose = ImageResource(name: "carplay_close", bundle: resourceBundle)

    /// The "carplay_feedback" asset catalog image resource.
    static let carplayFeedback = ImageResource(name: "carplay_feedback", bundle: resourceBundle)

    /// The "carplay_locate" asset catalog image resource.
    static let carplayLocate = ImageResource(name: "carplay_locate", bundle: resourceBundle)

    /// The "carplay_minus" asset catalog image resource.
    static let carplayMinus = ImageResource(name: "carplay_minus", bundle: resourceBundle)

    /// The "carplay_overview" asset catalog image resource.
    static let carplayOverview = ImageResource(name: "carplay_overview", bundle: resourceBundle)

    /// The "carplay_pan" asset catalog image resource.
    static let carplayPan = ImageResource(name: "carplay_pan", bundle: resourceBundle)

    /// The "carplay_plus" asset catalog image resource.
    static let carplayPlus = ImageResource(name: "carplay_plus", bundle: resourceBundle)

    /// The "carplay_search" asset catalog image resource.
    static let carplaySearch = ImageResource(name: "carplay_search", bundle: resourceBundle)

    /// The "carplay_volume_off" asset catalog image resource.
    static let carplayVolumeOff = ImageResource(name: "carplay_volume_off", bundle: resourceBundle)

    /// The "carplay_volume_on" asset catalog image resource.
    static let carplayVolumeOn = ImageResource(name: "carplay_volume_on", bundle: resourceBundle)

    /// The "close" asset catalog image resource.
    static let close = ImageResource(name: "close", bundle: resourceBundle)

    /// The "confusing_audio" asset catalog image resource.
    static let confusingAudio = ImageResource(name: "confusing_audio", bundle: resourceBundle)

    /// The "debug" asset catalog image resource.
    static let debug = ImageResource(name: "debug", bundle: resourceBundle)

    /// The "default_marker" asset catalog image resource.
    static let defaultMarker = ImageResource(name: "default_marker", bundle: resourceBundle)

    /// The "exit-left" asset catalog image resource.
    static let exitLeft = ImageResource(name: "exit-left", bundle: resourceBundle)

    /// The "exit-right" asset catalog image resource.
    static let exitRight = ImageResource(name: "exit-right", bundle: resourceBundle)

    /// The "feedback" asset catalog image resource.
    static let feedback = ImageResource(name: "feedback", bundle: resourceBundle)

    /// The "follow" asset catalog image resource.
    static let follow = ImageResource(name: "follow", bundle: resourceBundle)

    /// The "illegal_route" asset catalog image resource.
    static let illegalRoute = ImageResource(name: "illegal_route", bundle: resourceBundle)

    /// The "incorrect_visual" asset catalog image resource.
    static let incorrectVisual = ImageResource(name: "incorrect_visual", bundle: resourceBundle)

    /// The "location" asset catalog image resource.
    static let location = ImageResource(name: "location", bundle: resourceBundle)

    /// The "minus" asset catalog image resource.
    static let minus = ImageResource(name: "minus", bundle: resourceBundle)

    /// The "north-lock" asset catalog image resource.
    static let northLock = ImageResource(name: "north-lock", bundle: resourceBundle)

    /// The "overview" asset catalog image resource.
    static let overview = ImageResource(name: "overview", bundle: resourceBundle)

    /// The "pan-map" asset catalog image resource.
    static let panMap = ImageResource(name: "pan-map", bundle: resourceBundle)

    /// The "pin" asset catalog image resource.
    static let pin = ImageResource(name: "pin", bundle: resourceBundle)

    /// The "plus" asset catalog image resource.
    static let plus = ImageResource(name: "plus", bundle: resourceBundle)

    /// The "positioning" asset catalog image resource.
    static let positioning = ImageResource(name: "positioning", bundle: resourceBundle)

    /// The "preview_overview" asset catalog image resource.
    static let previewOverview = ImageResource(name: "preview_overview", bundle: resourceBundle)

    /// The "recenter" asset catalog image resource.
    static let recenter = ImageResource(name: "recenter", bundle: resourceBundle)

    /// The "report_checkmark" asset catalog image resource.
    static let reportCheckmark = ImageResource(name: "report_checkmark", bundle: resourceBundle)

    /// The "road_closure" asset catalog image resource.
    static let roadClosure = ImageResource(name: "road_closure", bundle: resourceBundle)

    /// The "route_quality" asset catalog image resource.
    static let routeQuality = ImageResource(name: "route_quality", bundle: resourceBundle)

    /// The "scroll" asset catalog image resource.
    static let scroll = ImageResource(name: "scroll", bundle: resourceBundle)

    /// The "search-monocle" asset catalog image resource.
    static let searchMonocle = ImageResource(name: "search-monocle", bundle: resourceBundle)

    /// The "star" asset catalog image resource.
    static let star = ImageResource(name: "star", bundle: resourceBundle)

    /// The "start" asset catalog image resource.
    static let start = ImageResource(name: "start", bundle: resourceBundle)

    /// The "time" asset catalog image resource.
    static let time = ImageResource(name: "time", bundle: resourceBundle)

    /// The "triangle" asset catalog image resource.
    static let triangle = ImageResource(name: "triangle", bundle: resourceBundle)

    /// The "volume_off" asset catalog image resource.
    static let volumeOff = ImageResource(name: "volume_off", bundle: resourceBundle)

    /// The "volume_up" asset catalog image resource.
    static let volumeUp = ImageResource(name: "volume_up", bundle: resourceBundle)

}

// MARK: - Backwards Deployment Support -

/// A color resource.
struct ColorResource: Hashable {

    /// An asset catalog color resource name.
    fileprivate let name: String

    /// An asset catalog color resource bundle.
    fileprivate let bundle: Bundle

    /// Initialize a `ColorResource` with `name` and `bundle`.
    init(name: String, bundle: Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

/// An image resource.
struct ImageResource: Hashable {

    /// An asset catalog image resource name.
    fileprivate let name: String

    /// An asset catalog image resource bundle.
    fileprivate let bundle: Bundle

    /// Initialize an `ImageResource` with `name` and `bundle`.
    init(name: String, bundle: Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// Initialize a `NSColor` with a color resource.
    convenience init(resource: ColorResource) {
        self.init(named: NSColor.Name(resource.name), bundle: resource.bundle)!
    }

}

protocol _ACResourceInitProtocol {}
extension AppKit.NSImage: _ACResourceInitProtocol {}

@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension _ACResourceInitProtocol {

    /// Initialize a `NSImage` with an image resource.
    init(resource: ImageResource) {
        self = resource.bundle.image(forResource: NSImage.Name(resource.name))! as! Self
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// Initialize a `UIColor` with a color resource.
    convenience init(resource: ColorResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}

@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// Initialize a `UIImage` with an image resource.
    convenience init(resource: ImageResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    /// Initialize a `Color` with a color resource.
    init(_ resource: ColorResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Image {

    /// Initialize an `Image` with an image resource.
    init(_ resource: ImageResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}
#endif
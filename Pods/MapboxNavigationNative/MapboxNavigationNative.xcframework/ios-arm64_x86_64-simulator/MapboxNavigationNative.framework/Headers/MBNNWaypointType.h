// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

// NOLINTNEXTLINE(modernize-use-using)
typedef NS_ENUM(NSInteger, MBNNWaypointType)
{
    /** Not silent and not EV Charging waypoint. */
    MBNNWaypointTypeRegular,
    /** Waypoint doesn't create a new leg. */
    MBNNWaypointTypeSilent,
    /** Waypoint added by server. Represents an electric vehicle charging station. */
    MBNNWaypointTypeEvCharging
} NS_SWIFT_NAME(WaypointType);

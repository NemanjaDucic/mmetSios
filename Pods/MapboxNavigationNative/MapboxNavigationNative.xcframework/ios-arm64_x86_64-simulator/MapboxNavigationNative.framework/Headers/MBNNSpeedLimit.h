// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <MapboxNavigationNative/MBNNSpeedLimitSign.h>
#import <MapboxNavigationNative/MBNNSpeedLimitUnit.h>

NS_SWIFT_NAME(SpeedLimit)
__attribute__((visibility ("default")))
@interface MBNNSpeedLimit : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithSpeedKmph:(nullable NSNumber *)speedKmph
                               localeUnit:(MBNNSpeedLimitUnit)localeUnit
                               localeSign:(MBNNSpeedLimitSign)localeSign;

/**
 * speed in kilometres per hour
 *  `nullopt` for unlimited speed limit
 */
@property (nonatomic, readonly, nullable) NSNumber *speedKmph;

/** default unit */
@property (nonatomic, readonly) MBNNSpeedLimitUnit localeUnit;

/** default sign */
@property (nonatomic, readonly) MBNNSpeedLimitSign localeSign;


@end

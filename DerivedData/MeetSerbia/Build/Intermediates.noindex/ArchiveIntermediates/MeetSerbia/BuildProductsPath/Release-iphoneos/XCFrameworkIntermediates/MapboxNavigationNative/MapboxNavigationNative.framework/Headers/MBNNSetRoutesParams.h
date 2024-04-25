// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

@protocol MBNNRouteInterface;

NS_SWIFT_NAME(SetRoutesParams)
__attribute__((visibility ("default")))
@interface MBNNSetRoutesParams : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithPrimaryRoute:(nonnull id<MBNNRouteInterface>)primaryRoute
                                    legIndex:(uint32_t)legIndex
                           alternativeRoutes:(nonnull NSArray<id<MBNNRouteInterface>> *)alternativeRoutes;

@property (nonatomic, readonly, nonnull) id<MBNNRouteInterface> primaryRoute;
/** Leg index of primary route. Can be >0 in the case of switch from alternative route back to main route. */
@property (nonatomic, readonly) uint32_t legIndex;

@property (nonatomic, readonly, nonnull, copy) NSArray<id<MBNNRouteInterface>> *alternativeRoutes;

@end

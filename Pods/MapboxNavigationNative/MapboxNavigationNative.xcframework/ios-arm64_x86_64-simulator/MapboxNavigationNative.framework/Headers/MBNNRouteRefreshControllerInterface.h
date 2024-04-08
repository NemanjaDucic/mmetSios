// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

@class MBNNRouteRefreshControllerOptions;
@protocol MBNNRouteRefreshObserver;

NS_SWIFT_NAME(RouteRefreshControllerInterface)
@protocol MBNNRouteRefreshControllerInterface
/**
 * Adds an observer of refresh events (update, fail, cancel)
 * @param  observer  object with corresponding callbacks
 */
- (void)addObserverForObserver:(nonnull id<MBNNRouteRefreshObserver>)observer;
/**
 * Remove specified observer
 * @param  observer  object that was added by addObserver
 */
- (void)removeObserverForObserver:(nonnull id<MBNNRouteRefreshObserver>)observer;
/** Remove all observers that was added by addObserver */
- (void)removeAllObservers;
/**
 * Refresh specific route
 * @param options  route parameters
 *
 * @return requestId of the refresh. Could be used to cancel
 */
- (uint64_t)routeRefreshForOptions:(nonnull MBNNRouteRefreshControllerOptions *)options __attribute__((deprecated("This method should not be used anymore. Use Navigator API to refresh routes.")));
/**
 * Cancel route refresh by requestId
 * @param id  refresh request id that was returned by routeRefresh
 */
- (void)cancelForId:(uint64_t)id __attribute__((deprecated("This method should not be used anymore. Use Navigator API to refresh routes.")));
/**
 * Start refreshing specific route
 * @param intervalMs  period of refresh
 * @param options  route parameters
 */
- (void)startForIntervalMs:(uint64_t)intervalMs
                   options:(nonnull MBNNRouteRefreshControllerOptions *)options __attribute__((deprecated("This method should not be used anymore. Use Navigator API to refresh routes.")));
/** Stop refreshing route */
- (void)stop __attribute__((deprecated("This method should not be used anymore. Use Navigator API to refresh routes.")));
@end

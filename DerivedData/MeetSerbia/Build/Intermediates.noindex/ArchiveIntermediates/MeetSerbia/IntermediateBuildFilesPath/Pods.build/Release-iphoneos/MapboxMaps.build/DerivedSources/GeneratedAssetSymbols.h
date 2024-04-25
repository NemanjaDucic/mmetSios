#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "location-dot-inner" asset catalog image resource.
static NSString * const ACImageNameLocationDotInner AC_SWIFT_PRIVATE = @"location-dot-inner";

/// The "location-dot-outer" asset catalog image resource.
static NSString * const ACImageNameLocationDotOuter AC_SWIFT_PRIVATE = @"location-dot-outer";

/// The "triangle" asset catalog image resource.
static NSString * const ACImageNameTriangle AC_SWIFT_PRIVATE = @"triangle";

#undef AC_SWIFT_PRIVATE
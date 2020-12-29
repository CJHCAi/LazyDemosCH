//
//  GSSynthesizeSingleton.h
//

#ifndef __has_feature
#define __has_feature(x) 0
#endif

#if __has_feature(objc_arc)
#include <dispatch/dispatch.h>

#define GSSynthesizeSingleton(prefix, className) \
+ (instancetype)shared##className {\
    static dispatch_once_t predicate = 0;\
    static prefix##className *shared##className = nil;\
    dispatch_once(&predicate, ^{\
        shared##className = [[super allocWithZone:NULL] init];\
    });\
    return shared##className;\
}\
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone {\
    return nil;\
}\
\
- (id)copyWithZone:(struct _NSZone *)zone {\
    return self;\
}
#else
#define GSSynthesizeSingleton(prefix, className) \
+ (instancetype)shared##className {\
    static prefix##className *shared##className = nil;\
    @synchronized(self) {\
        if (shared##className == nil) {\
            shared##className = [[super allocWithZone:NULL] init];\
        }\
    }\
    return shared##className;\
}\
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone {\
    return nil;\
}\
\
- (id)copyWithZone:(struct _NSZone *)zone {\
    return self;\
}\
\
- (instancetype)retain {\
    return self;\
}\
\
- (oneway void)release {\
}\
\
- (instancetype)autorelease {\
    return self;\
}\
\
- (NSUInteger)retainCount {\
    return NSUIntegerMax;\
}
#endif

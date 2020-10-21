//
//  SJFitOnScreenManagerProtocol.h
//  SJBaseVideoPlayer
//
//  Created by BlueDancer on 2018/12/31.
//

#ifndef SJFitOnScreenManagerProtocol_h
#define SJFitOnScreenManagerProtocol_h
#import <UIKit/UIKit.h>
@protocol SJFitOnScreenManagerObserver;

typedef enum : NSUInteger {
    SJFitOnScreenStateStart,
    SJFitOnScreenStateEnd,
} SJFitOnScreenState;

@protocol SJFitOnScreenManager <NSObject>
- (instancetype)initWithTarget:(__strong UIView *)target targetSuperview:(__strong UIView *)superview;
- (id<SJFitOnScreenManagerObserver>)getObserver;

@property (nonatomic, readonly) SJFitOnScreenState state;
@property (nonatomic) NSTimeInterval duration;

/// Fit On Screen
@property (nonatomic, getter=isFitOnScreen) BOOL fitOnScreen;
- (void)setFitOnScreen:(BOOL)fitOnScreen animated:(BOOL)animated;
- (void)setFitOnScreen:(BOOL)fitOnScreen animated:(BOOL)animated completionHandler:(nullable void(^)(id<SJFitOnScreenManager> mgr))completionHandler;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;
@end


@protocol SJFitOnScreenManagerObserver <NSObject>
@property (nonatomic, copy, nullable) void(^fitOnScreenWillBeginExeBlock)(id<SJFitOnScreenManager> mgr);
@property (nonatomic, copy, nullable) void(^fitOnScreenDidEndExeBlock)(id<SJFitOnScreenManager> mgr);
@end
#endif /* SJFitOnScreenManagerProtocol_h */

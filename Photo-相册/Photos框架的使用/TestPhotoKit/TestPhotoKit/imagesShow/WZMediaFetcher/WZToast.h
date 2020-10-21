//
//  WZToast.h



#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, WZToastPositionType) {
    WZToastPositionTypeMiddle       = 0,
    WZToastPositionTypeTop          = 1,
    WZToastPositionTypeBottom       = 2,
};

@interface WZToast : UIView


+ (void)toastWithContent:(NSString *)content;

+ (void)toastWithContent:(NSString *)content duration:(NSTimeInterval)duration;

+ (void)toastWithContent:(NSString *)content position:(WZToastPositionType)position;

+ (void)toastWithContent:(NSString *)content
                        position:(WZToastPositionType)position
                        duration:(NSTimeInterval)duration;

+ (void)toastWithContent:(NSString *)content
                        position:(WZToastPositionType)position
                   customOriginY:(CGFloat)customOriginY;

+ (void)toastWithContent:(NSString *)content
                        position:(WZToastPositionType)position
                    customOrigin:(CGPoint)customOrigin;
@end

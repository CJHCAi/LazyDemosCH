#import <UIKit/UIKit.h>

@interface DDYShakeView : UIView

+ (instancetype)viewWithFrame:(CGRect)frame;

+ (void)shakeWarning:(BOOL)mySend;

+ (void)scaleWarning;

@end

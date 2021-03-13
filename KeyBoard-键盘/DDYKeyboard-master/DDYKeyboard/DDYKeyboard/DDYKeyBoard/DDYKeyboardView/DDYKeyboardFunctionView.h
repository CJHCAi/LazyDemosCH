#import <UIKit/UIKit.h>
#import "DDYKeyboardConfig.h"

@interface DDYKeyboardFunctionView : UIView

@property (nonatomic, assign, readonly) BOOL show;

@property (nonatomic, assign, readonly) BOOL refresh;

@property (nonatomic, assign) DDYKeyboardState state;

@end

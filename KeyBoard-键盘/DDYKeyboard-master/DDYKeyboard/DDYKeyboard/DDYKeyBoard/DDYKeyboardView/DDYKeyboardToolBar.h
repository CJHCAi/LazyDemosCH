#import <UIKit/UIKit.h>
#import "DDYKeyboardConfig.h"

@interface DDYKeyboardToolBar : UIView

@property (nonatomic, copy) void (^keyboardStateChangedBlock)(DDYKeyboardState changedState);

@property (nonatomic, assign) DDYKeyboardState allState;

- (void)resetToolBarState;

@end

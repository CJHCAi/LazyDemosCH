#import <UIKit/UIKit.h>
#import "DDYKeyboardConfig.h"

@interface DDYKeyboardTextBar : UIView

@property (nonatomic, copy) void (^textBarChangeStatedBlock)(DDYKeyboardState changedState);

@property (nonatomic, copy) void (^textBarSendBlock)(UITextView *textView);

@property (nonatomic, copy) void (^textBarUpdateFrameBlock)(void);

@property (nonatomic, strong) UIImage *inputBackImage;

- (void)updateFrame;

- (BOOL)becomeFirstResponder;

- (BOOL)resignFirstResponder;

@end

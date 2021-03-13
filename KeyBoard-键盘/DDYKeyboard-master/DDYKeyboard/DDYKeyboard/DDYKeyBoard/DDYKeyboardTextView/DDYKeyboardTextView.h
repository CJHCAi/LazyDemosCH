#import <UIKit/UIKit.h>

@interface DDYKeyboardTextView : UITextView

@property (nonatomic, copy) void (^sendBlock)(UITextView *textView);

+ (instancetype)viewWithFrame:(CGRect)frame;

@end

#import <UIKit/UIKit.h>

@interface DDYVoiceIndicator : UIView

@property (nonatomic, copy) void (^changeIndexBlock)(NSInteger selectedIndex);

+ (instancetype)indicatorWithFrame:(CGRect)frame;

- (void)scrollWithAssociateScrollView:(UIScrollView *)scrollView;

@end

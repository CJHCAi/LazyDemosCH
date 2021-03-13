#import "DDYMoreView.h"
#import "DDYKeyboardConfig.h"

@implementation DDYMoreView

+ (instancetype)viewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // 测试颜色
        self.backgroundColor = DDYRandomColor;
    }
    return self;
}

@end

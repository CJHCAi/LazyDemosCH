#import "DDYKeyboardTextView.h"
#import "DDYKeyboardConfig.h"

@interface DDYKeyboardTextView()<UITextViewDelegate>

@end

@implementation DDYKeyboardTextView


+ (instancetype)viewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setFont:[UIFont systemFontOfSize:kbTextViewFont]];
        [self setTextContainerInset:UIEdgeInsetsMake(0, 5, 0, 0)];
        [self setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self setDelegate:self];
        [self setShowsVerticalScrollIndicator:NO];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setBounces:NO];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setEnablesReturnKeyAutomatically:YES];
        
        
        [self setPlaceholder:@"Test Message Placeholder"];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [self ddy_AllowsNonContiguousLayout:NO];
        [self setDdy_CenterY:self.ddy_H/2.];
        [self ddy_AutoHeightWithMinHeight:self.bounds.size.height maxHeight:90];
        
        // 防止图片表情误触
        if (@available(iOS 11.0, *)) {
            self.textDragInteraction.enabled = NO;
        }
    }
    return self;
}

#pragma mark 私有方法
- (void)updateTextView {
    // 没有输入(输入全是空格)或者只拼音未输入完全状态
    if ([NSString ddy_blankString:self.text] || [self positionFromPosition:self.markedTextRange.start offset:0]) return;
    
    NSRange selectedRange = self.selectedRange;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self.text];
    
}

#pragma mark UITextViewDelegate
#pragma mark 即将编辑
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSLog(@"即将编辑");
    return YES;
}

#pragma mark 已经停止编辑
- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"已经停止编辑");
}

#pragma mark 处理发送
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([@"\n" isEqualToString:text]) {
        if (self.sendBlock) {
            self.sendBlock(textView);
        }
        return NO;
    }
    return YES;
}

#pragma mark - UI层级调试时出现 -[UITextView _firstBaselineOffsetFromTop] only valid when using auto layout
- (void)_firstBaselineOffsetFromTop {}
- (void)_baselineOffsetFromBottom {}

@end

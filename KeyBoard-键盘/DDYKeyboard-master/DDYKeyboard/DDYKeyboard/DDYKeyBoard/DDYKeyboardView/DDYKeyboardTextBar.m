#import "DDYKeyboardTextBar.h"

@interface DDYKeyboardTextBar()<UITextViewDelegate>

@property (nonatomic, strong) UIImageView *textBackgroundView;

@property (nonatomic, strong) UITextView *textView;

@end

@implementation DDYKeyboardTextBar

- (UIImageView *)textBackgroundView {
    if (!_textBackgroundView) {
        _textBackgroundView = [[UIImageView alloc] init];
        _textBackgroundView.contentMode = UIViewContentModeScaleAspectFill;
        _textBackgroundView.backgroundColor = [UIColor whiteColor];
        _textBackgroundView.userInteractionEnabled = YES;
    }
    return _textBackgroundView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        [_textView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_textView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_textView setDelegate:self];
        [_textView setShowsVerticalScrollIndicator:NO];
        [_textView setShowsHorizontalScrollIndicator:NO];
        [_textView setBounces:NO];
        [_textView setReturnKeyType:UIReturnKeySend];
        [_textView setEnablesReturnKeyAutomatically:YES];
        
        [_textView setPlaceholder:@"Test Message Placeholder"];
        [_textView setPlaceholderColor:[UIColor lightGrayColor]];
        [_textView ddy_AllowsNonContiguousLayout:NO];
        [_textView ddy_AutoHeightWithFont:[UIFont systemFontOfSize:kbTextViewFont] minLineNumber:1 maxLineNumber:kbTextViewMaxLine];
        
        // 防止图片表情误触
        if (@available(iOS 11.0, *)) {
            _textView.textDragInteraction.enabled = NO;
        }
        
        __weak __typeof (self)weakSelf = self;
        _textView.autoHeightBlock = ^(CGFloat height) {
            __strong __typeof (weakSelf)strongSelf = weakSelf;
            [strongSelf updateFrame];
        };
    }
    return _textView;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.textBackgroundView];
        [self.textBackgroundView addSubview:self.textView];
        [self updateFrame];
        [self ddy_AddTapTarget:self action:@selector(handleTap)];
    }
    return self;
}

- (void)updateFrame {
    self.textView.frame = CGRectMake(kbTextViewMargin, kbTextViewMargin, DDYSCREENW-2*kbTextBarBgMargin-2*kbTextViewMargin, self.textView.ddy_H);
    self.textBackgroundView.frame = CGRectMake(kbTextBarBgMargin, kbTextBarBgMargin, DDYSCREENW-2*kbTextBarBgMargin, self.textView.ddy_H+2*kbTextViewMargin);
    self.ddy_H = self.textBackgroundView.ddy_H + 2*kbTextBarBgMargin;
    if (self.textBarUpdateFrameBlock) self.textBarUpdateFrameBlock();
}

- (BOOL)becomeFirstResponder {
    return [self.textView becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [self.textView resignFirstResponder];
}

#pragma mark UITextViewDelegate
#pragma mark 即将编辑
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSLog(@"即将编辑");
    if (self.textBarChangeStatedBlock) self.textBarChangeStatedBlock(DDYKeyboardStateSystem);
    return YES;
}

#pragma mark 已经停止编辑
- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"已经停止编辑");
}

#pragma mark 处理发送
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([@"\n" isEqualToString:text]) {
        if (self.textBarSendBlock) {
            self.textBarSendBlock(textView);
        }
        return NO;
    }
    return YES;
}


- (void)setInputBackImage:(UIImage *)inputBackImage {
    _inputBackImage = inputBackImage;
    self.textBackgroundView.image = inputBackImage;
}

- (void)handleTap {
    [self.textView becomeFirstResponder];
}

#pragma mark - UI层级调试时出现 -[UITextView _firstBaselineOffsetFromTop] only valid when using auto layout
- (void)_firstBaselineOffsetFromTop {}
- (void)_baselineOffsetFromBottom {}

@end

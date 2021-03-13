#import "DDYKeyboard.h"
#import "DDYKeyboardTextBar.h"
#import "DDYKeyboardToolBar.h"
#import "DDYKeyboardFunctionView.h"

@interface DDYKeyboard ()
/** 顶部文本输入 */
@property (nonatomic, strong) DDYKeyboardTextBar *textBar;
/** 中部横排按钮 */
@property (nonatomic, strong) DDYKeyboardToolBar *toolBar;
/** 下部功能实现 */
@property (nonatomic, strong) DDYKeyboardFunctionView *functionView;
/** 键盘状态 */
@property (nonatomic, assign) DDYKeyboardState keyboardState;
/** 键盘高度 */
@property (nonatomic, assign) CGFloat keyboardH;
/** 功能区高度 */
@property (nonatomic, assign) CGFloat functionViewH;

@end

@implementation DDYKeyboard

- (DDYKeyboardTextBar *)textBar {
    if (!_textBar) {
        _textBar = [[DDYKeyboardTextBar alloc] init];
        [_textBar updateFrame];
        __weak __typeof (self)weakSelf = self;
        [_textBar setTextBarSendBlock:^(UITextView *textView) {
            
        }];
        [_textBar setTextBarChangeStatedBlock:^(DDYKeyboardState changedState) {
            __strong __typeof (weakSelf)strongSelf = weakSelf;
            strongSelf.keyboardState = changedState;
        }];
        [_textBar setTextBarUpdateFrameBlock:^{
            __strong __typeof (weakSelf)strongSelf = weakSelf;
            [strongSelf updateFrameAnimate:NO];
        }];
    }
    return _textBar;
}

- (DDYKeyboardToolBar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[DDYKeyboardToolBar alloc] init];
        __weak __typeof (self)weakSelf = self;
        [_toolBar setKeyboardStateChangedBlock:^(DDYKeyboardState changedState) {
            __strong __typeof (weakSelf)strongSelf = weakSelf;
            strongSelf.keyboardState = changedState;
        }];
    }
    return _toolBar;
}

- (DDYKeyboardFunctionView *)functionView {
    if (!_functionView) {
        _functionView = [[DDYKeyboardFunctionView alloc] initWithFrame:CGRectMake(0, 0, DDYSCREENW, kbFunctionViewH)];
    }
    return _functionView;
}

+ (instancetype)keyboardWithType:(DDYKeyboardType)type {
    return [[self alloc] initWithType:type];
}

- (instancetype)initWithType:(DDYKeyboardType)type {
    if (self = [super initWithFrame:CGRectMake(0, DDYSCREENH, DDYSCREENW, 80)]) {
        [self addSubview:self.textBar];
        [self addSubview:self.toolBar];
        [self addSubview:self.functionView];
        [self setToolBarType:type];
        [self addNotification];
    }
    return self;
}

#pragma mark // 设置ToolBar
- (void)setToolBarType:(DDYKeyboardType)type {
    if (type == DDYKeyboardTypeStranger) {
        self.toolBar.allState = DDYKeyboardStateVoice | DDYKeyboardStatePhoto | DDYKeyboardStateVideo | DDYKeyboardStateGif |
        DDYKeyboardStateEmoji | DDYKeyboardStateMore;
    } else if (type == DDYKeyboardTypeSingle) {
        self.toolBar.allState = DDYKeyboardStateVoice | DDYKeyboardStatePhoto | DDYKeyboardStateVideo | DDYKeyboardStateShake |
        DDYKeyboardStateGif   | DDYKeyboardStateRedBag| DDYKeyboardStateEmoji | DDYKeyboardStateMore;
    } else if (type == DDYKeyboardTypeGroup) {
        self.toolBar.allState = DDYKeyboardStateVoice | DDYKeyboardStatePhoto | DDYKeyboardStateVideo | DDYKeyboardStateGif |
        DDYKeyboardStateRedBag| DDYKeyboardStateEmoji | DDYKeyboardStateMore;
    }
}

#pragma mark - 通知 Notification
#pragma mark 注册通知
- (void)addNotification {
    // 键盘将要弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    // 键盘将要收回通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark 键盘将要弹出通知响应
- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat keyboardH1 = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    CGFloat keyboardH2 = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    // 键盘弹起可能存在多次回调
    if (keyboardH1 > 0) {
        self.keyboardH = keyboardH2;
        [self updateFrameAnimate:YES];
    }
}

#pragma mark 键盘将要收回通知响应
- (void)keyboardWillHide:(NSNotification *)notification {
    self.keyboardH = 0;
    // 三方键盘有的自带收回功能，所以要保证状态正确
    if (_keyboardState == DDYKeyboardStateSystem) {
        self.keyboardState = DDYKeyboardStateNone;
    }
    [self updateFrameAnimate:YES];
}

#pragma mark 改变状态
// 如果自定义功能状态(!none && !system) 和 键盘收回状态(none) 相互切换时，则需要更新布局
- (void)setKeyboardState:(DDYKeyboardState)keyboardState {
    _keyboardState = keyboardState;
    
    self.functionView.state = keyboardState;
    
    if (keyboardState == DDYKeyboardStateNone || keyboardState == DDYKeyboardStateSystem) {
        [self.toolBar resetToolBarState];
    }
    if (keyboardState != DDYKeyboardStateSystem &&  keyboardState != DDYKeyboardStateVideo) {
        self.functionView.refresh ? [self updateFrameAnimate:YES] : [self.textBar resignFirstResponder];
    }
}


- (void)updateFrameAnimate:(BOOL)animate { NSLog(@"%@", NSStringFromCGRect(self.frame));
    [UIView animateWithDuration:animate ? 0.25 : 0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.functionView.alpha = self.functionView.show ? 1 : 0.1;
        self.textBar.frame = CGRectMake(0, 0, DDYSCREENW, self.textBar.ddy_H);
        self.toolBar.frame = CGRectMake(0, self.textBar.ddy_Bottom, DDYSCREENW, kbToolBarH);
        self.functionView.frame = CGRectMake(0, self.toolBar.ddy_Bottom, DDYSCREENW, self.functionView.show ? kbFunctionViewH : 0);
        self.ddy_H = self.textBar.ddy_H + self.toolBar.ddy_H + (self.functionView.show ? kbFunctionViewH : 0);
        self.ddy_Bottom = self.superview.ddy_H - (self.keyboardH>0 ? self.keyboardH : DDYSafeInsets(self.superview).bottom);
        self.associateTableView.ddy_H = self.ddy_Y;
    } completion:^(BOOL finished) { }];
}

- (void)keyboardDown {
    self.keyboardState = DDYKeyboardStateNone;
}

@end

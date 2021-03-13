#import "DDYKeyboardToolBar.h"

static inline NSString *bundleImgName(NSString *imgName) {return [NSString stringWithFormat:@"DDYKeyboard.bundle/%@", imgName];}

@interface DDYKeyboardToolBar ()
/** 按钮数组 */
@property (nonatomic, strong) NSMutableArray *buttonArray;
/** 当前选择的按钮 */
@property (nonatomic, strong) UIButton *currentButton;

@end

@implementation DDYKeyboardToolBar

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (void)setAllState:(DDYKeyboardState)allState {
    _allState = allState;
    
    if (allState & DDYKeyboardStateVoice) {
        [self.buttonArray addObject:[self buttonImg:@"voiceN" selectedImg:@"voiceS" tag:DDYKeyboardStateVoice]];
    }
    if (allState & DDYKeyboardStatePhoto) {
        [self.buttonArray addObject:[self buttonImg:@"photoN" selectedImg:@"photoS" tag:DDYKeyboardStatePhoto]];
    }
    if (allState & DDYKeyboardStateVideo) {
        [self.buttonArray addObject:[self buttonImg:@"videoN" selectedImg:@"videoS" tag:DDYKeyboardStateVideo]];
    }
    if (allState & DDYKeyboardStateShake) {
        [self.buttonArray addObject:[self buttonImg:@"shakeN" selectedImg:@"shakeS" tag:DDYKeyboardStateShake]];
    }
    if (allState & DDYKeyboardStateGif) {
        [self.buttonArray addObject:[self buttonImg:@"gifN" selectedImg:@"gifS" tag:DDYKeyboardStateGif]];
    }
    if (allState & DDYKeyboardStateRedBag) {
        [self.buttonArray addObject:[self buttonImg:@"redN" selectedImg:@"redS" tag:DDYKeyboardStateRedBag]];
    }
    if (allState & DDYKeyboardStateEmoji) {
        [self.buttonArray addObject:[self buttonImg:@"emojiN" selectedImg:@"emojiS" tag:DDYKeyboardStateEmoji]];
    }
    if (allState & DDYKeyboardStateMore) {
        [self.buttonArray addObject:[self buttonImg:@"moreN" selectedImg:@"moreS" tag:DDYKeyboardStateMore]];
    }
    [self layoutButton];
}

- (UIButton *)buttonImg:(NSString *)img selectedImg:(NSString *)imgS tag:(NSUInteger)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:bundleImgName(img)] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:bundleImgName(imgS)] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTag:tag];
    [self addSubview:button];
    return button;
}

- (void)handleClick:(UIButton *)button {
    if (self.keyboardStateChangedBlock) {
        if (button.tag & DDYKeyboardStateVideo) {
            self.keyboardStateChangedBlock(DDYKeyboardStateVideo);
        } else if (_currentButton == button && _currentButton.selected) {
            _currentButton.selected = NO;
            self.keyboardStateChangedBlock(DDYKeyboardStateNone);
        } else {
            _currentButton.selected = NO;
            _currentButton = button;
            _currentButton.selected = YES;
            self.keyboardStateChangedBlock((DDYKeyboardState)button.tag);
        }
    }
}

- (void)resetToolBarState {
    if (_currentButton) {
        _currentButton.selected = NO;
    }
}


- (void)layoutButton {
    // 按钮布局
    UIButton *lastButton = nil;
    CGFloat buttonMargin = (DDYSCREENW - kbToolBarButtonWH * self.buttonArray.count) / (self.buttonArray.count + 1.);
    for (UIButton *button in self.buttonArray) {
        button.frame = CGRectMake((lastButton ? lastButton.ddy_Right : 0) + buttonMargin, 0, kbToolBarButtonWH, kbToolBarButtonWH);
        lastButton = button;
    }
}

@end

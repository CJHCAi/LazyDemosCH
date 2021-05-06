//
//  YHChatImageView.m
//  YHChat
//
//  Created by samuelandkevin on 17/3/22.
//  Copyright © 2017年 samuelandkevin. All rights reserved.
//

#import "YHChatImageView.h"
#import "UIImage+Extension.h"

@implementation YHChatImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupTap];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setupTap];
    [super awakeFromNib];
}

/** 设置敲击手势 */
- (void)setupTap
{
    //已经在stroyboard设置了与用户交互,也可以用纯代码设置
    self.userInteractionEnabled = YES;
    
    //当前控件是label 所以是给label添加敲击手势
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidHide) name:UIMenuControllerDidHideMenuNotification object:nil];
}


- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        if(menu.isMenuVisible) return;
        
        NSArray *menuItems = @[
                               [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(retweet:)]
                               ];
        if (_isReceiver) {
            menuItems = @[
                          [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(retweet:)],[[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(withdraw:)]
                          ];
        }
        menu.menuItems = menuItems;
        
        [menu setTargetRect:self.bounds inView:self];
        //    [menu setTargetRect:self.frame inView:self.superview];
        [menu setMenuVisible:YES animated:YES];
        
        self.backgroundColor = RGBCOLOR(230, 230, 230);
    }
    
    
    
}

#pragma mark - NSNotification
- (void)menuDidHide{
    [self finishChoosing];
}


#pragma mark - UIMenuController相关

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if ( ((action == @selector(retweet:) || (action == @selector(withdraw:))) && self.image))
        return YES;
    
    return NO;
}
#pragma mark - 监听MenuItem的点击事件

- (void)retweet:(UIMenuController *)menu{
    
    WeakSelf
    if (self.retweetImageBlock) {
        weakSelf.retweetImageBlock(weakSelf.image);
    }
    if (self.retweetVoiceBlock) {
        weakSelf.retweetVoiceBlock();
    }
    [self finishChoosing];
}

- (void)withdraw:(UIMenuController *)menu{
    
    WeakSelf
    if (self.withDrawImageBlock) {
        weakSelf.withDrawImageBlock(weakSelf.image);
    }
    if (self.withDrawVoiceBlock) {
        weakSelf.withDrawVoiceBlock();
    }
    [self finishChoosing];
}

#pragma mark - Private
//选择完毕
- (void)finishChoosing{
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Life
- (void)dealloc{
    DDLog(@"%s is dealloc",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

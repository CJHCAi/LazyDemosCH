//
//  JJLabel.m
//  TestDemo
//
//  Created by jiejin on 16/3/11.
//  Copyright © 2016年 jiejin. All rights reserved.
//

#import "JJLabel.h"
#import <CoreText/CoreText.h>


@implementation JJLabelItem

@end

@implementation JJLabel

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self addLongPressGesture];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self addLongPressGesture];
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addLongPressGesture];
    }
    return self;
}

// 清除通知
- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 添加长按手势
- (void)addLongPressGesture {
    
    self.userInteractionEnabled = YES;
    self.isCopy = YES;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress)];
    [self addGestureRecognizer:longPress];
    
    // 添加将要隐藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHidden) name:UIMenuControllerWillHideMenuNotification object:nil];
}

- (void)handleLongPress {
    
    if(!self.isCopy){
    
        return;
    }
    
    [self becomeFirstResponder];
    
    if(self.willShowMenu){
        
        self.willShowMenu();
    }
    
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(jjcopy:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyItem, nil]];
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

#pragma mark - rewrite
// 为了能接受到事件（能成为第一响应者），我们需要覆盖这个方法
- (BOOL)canBecomeFirstResponder {
    
    return YES;
}
// 针对复制的操作覆盖的方法
// 可以响应的方法
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(jjcopy:));
}

// 响应方法的实现
- (void)jjcopy:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    NSString *startStr = self.text;
    
    if(self.appendString.length > 0){
        
        startStr  = [startStr stringByAppendingString:self.appendString];
    }
    
    if(self.subFromIndexString.length > 0){
        
        NSRange markRange = [startStr rangeOfString:self.subFromIndexString];
        NSString *targetStr = [startStr substringFromIndex:(markRange.location + markRange.length)];
        
        pasteboard.string = targetStr;
        
    }else{
        
        pasteboard.string = startStr;
        
    }
}

#pragma mark - KVO

//- (void)registerForKVO
//{
//    for (NSString *keyPath in [self observableKeypaths]) {
//        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
//    }
//}
//
//- (NSArray *)observableKeypaths
//{
//    return @[@"characterSpace",@"lineSpace"];
//}
//
//- (void)updateUIForKeypath:(NSString *)keyPath
//{
//    
//    if ([keyPath isEqualToString:@"characterSpace"]) {
//     
//    } else if ([keyPath isEqualToString:@"lineSpace"]) {
//        
//    }
//
//}

- (CGFloat)getLableHeightWithMaxWidth:(CGFloat)maxWidth{

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.text];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0,self.text.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    // 行间距
    if(self.lineSpace > 0){
    
        [paragraphStyle setLineSpacing:self.lineSpace];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,self.text.length)];
    }
    
    // 字间距
    if(self.characterSpace > 0){
        
        long number = self.characterSpace;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString length])];
        
        CFRelease(num);
    }
    
     // 不同区域的文字
    if(self.changeArray.count > 0){
    
        for(JJLabelItem *item in self.changeArray){
        
            NSRange itemRange = [self.text rangeOfString:item.itemContent];
            [attributedString addAttribute:NSFontAttributeName value:item.itemFont range:itemRange];
            [attributedString addAttribute:NSForegroundColorAttributeName value:item.itemColor range:itemRange];
        }
    }
    
    self.attributedText = attributedString;
    
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];

    // 向上取整，防止画UI时lab的高度取整
    return ceil(rect.size.height);
}


#pragma mark - NotificationCenterAction

- (void)willHidden{
    
    if(self.willHiddenMenu){
        
        self.willHiddenMenu();
    }
}


@end

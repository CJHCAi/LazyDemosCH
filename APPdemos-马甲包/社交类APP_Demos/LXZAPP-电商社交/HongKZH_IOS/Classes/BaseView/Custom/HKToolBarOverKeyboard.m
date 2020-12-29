//
//  HKToolBarOverKeyboard.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKToolBarOverKeyboard.h"

#define HEIGHT 44
#define MAXITEM 5

@interface HKToolBarOverKeyboard()
{
    NSMutableArray *_buttons;
}
@property (nonatomic,readonly) UIView *sepLineUp;
@property (nonatomic,readonly) UIView *sepLineDown;
@property (nonatomic,readonly) NSArray *items;
@end

@implementation HKToolBarOverKeyboard

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _buttons = [NSMutableArray array];
        
        for (int i=0; i<MAXITEM; i++) {
            UIButton *bt = [HKComponentFactory buttonWithType:UIButtonTypeCustom
                                                        frame:CGRectZero
                                                        taget:self
                                                       action:@selector(buttonClicked:)
                                                   supperView:self];
            bt.tag = 1111+i;
            bt.hidden = YES;
            [_buttons addObject:bt];
            
            bt.frame = CGRectMake(20+20*i+25*i, frame.size.height/2.f-25/2.f, 25, 25);
        }
        
        //sep line
        _sepLineUp = [HKComponentFactory viewWithFrame:CGRectMake(0, 0, frame.size.width, 0.5) supperView:self];
        _sepLineDown = [HKComponentFactory viewWithFrame:CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5) supperView:self];
        _sepLineUp.backgroundColor = _sepLineDown.backgroundColor =UICOLOR_HEX(0xcccccc);
    }
    return self;
}

- (void)setItemsWithImageNames:(NSArray *)itemsWithImageNames
{
    if (itemsWithImageNames && itemsWithImageNames.count) {
        _itemsWithImageNames = itemsWithImageNames;
        
        //获取buttons
        for (int i=0;i<itemsWithImageNames.count;i++) {
            UIButton *bt = _buttons[i];
            bt.hidden = NO;
            [bt setImage:[UIImage imageNamed:itemsWithImageNames[i]] forState:UIControlStateNormal];
            
            //最后一个放最右边
            if (i>0 && i == itemsWithImageNames.count-1) {
                bt.frame = CGRectMake(self.frame.size.width - 25 - 20, self.frame.size.height/2.f-25/2.f, 25, 25);
            }
        }
    }
}

+ (id)initWithFrame:(CGRect)frame itemImageNames:(NSArray <NSString *> *)imageNames inView:(UIView *)view
{
    HKToolBarOverKeyboard *toolbar = [[HKToolBarOverKeyboard alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, HEIGHT)];
    
    toolbar.itemsWithImageNames = imageNames;
    
    if (view) {
        [view addSubview:toolbar];
        [view bringSubviewToFront:toolbar];
    }
    return toolbar;
}

- (void)buttonClicked:(id)btn
{
    UIButton *bt = (UIButton *)btn;
    if (self.clickItemCallback) {
        self.clickItemCallback(bt.tag - 1111);
    }
}

@end

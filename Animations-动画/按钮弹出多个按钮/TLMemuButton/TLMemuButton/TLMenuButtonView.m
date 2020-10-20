//
//  TLMenuButtonView.m
//  MiShu
//
//  Created by tianlei on 16/6/24.
//  Copyright © 2016年 Qzy. All rights reserved.
//

#import "TLMenuButtonView.h"
#define ColorWithRGB(r, g, b) [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:0.9]
#define kWindow [[UIApplication sharedApplication] keyWindow]

@interface TLMenuButtonView ()

@property (nonatomic, strong) TLMenuButton *menu1;

@property (nonatomic, strong) TLMenuButton *menu2;

@property (nonatomic, strong) TLMenuButton *menu3;

@property (nonatomic, strong) TLMenuButton *menu4;

@property (nonatomic, strong) TLMenuButton *menu5;

@end

static TLMenuButtonView *instanceMenuView;

@implementation TLMenuButtonView
- (instancetype)init{
    if (self = [super init]) {
//        [self ];
    }
    return self;
}


- (void)showItems{
    CGPoint center = self.centerPoint;
    CGFloat r = 180;
    CGPoint point1 = CGPointMake(center.x - r*cos(M_PI/12), center.y+r*sin(M_PI/12));
    CGPoint point2 = CGPointMake(center.x - r*cos(M_PI / 8-M_PI*3/48), center.y - r*sin(M_PI / 8-M_PI*3/48));
    CGPoint point3 = CGPointMake(center.x - r*cos(M_PI / 4-M_PI/24), center.y - r*sin(M_PI / 4-M_PI/24));
    CGPoint point4 = CGPointMake(center.x - r*cos(M_PI * 3 / 8-M_PI/48), center.y - r*sin(M_PI * 3 / 8-M_PI/48));
    CGPoint point5 = CGPointMake(center.x, center.y - r);
    
   // CGPoint point1 = CGPointMake(center.x - r*cos(M_PI/12), center.y+r*sin(M_PI/12));
    
    TLMenuButton *menu1 = [TLMenuButton buttonWithTitle:@"通用" imageTitle:@"icon_menu_general" center:center color:ColorWithRGB(93,198,78)];
    menu1.tag = 1;
    [menu1 addTarget:self action:@selector(_addExamApprovel:) forControlEvents:UIControlEventTouchUpInside];
    
   // CGPoint point2 = CGPointMake(center.x - r*cos(M_PI / 8-M_PI*3/48), center.y - r*sin(M_PI / 8-M_PI*3/48));
    TLMenuButton *menu2 = [TLMenuButton buttonWithTitle:@"请假" imageTitle:@"icon_menu_leave" center:center color:ColorWithRGB(242,104,90)];
     menu2.tag = 2;
    [menu2 addTarget:self action:@selector(_addExamApprovel:) forControlEvents:UIControlEventTouchUpInside];
    
   // CGPoint point3 = CGPointMake(center.x - r*cos(M_PI / 4-M_PI/24), center.y - r*sin(M_PI / 4-M_PI/24));
    TLMenuButton *menu3 = [TLMenuButton buttonWithTitle:@"报销" imageTitle:@"icon_menu_reim" center:center color:ColorWithRGB(93,198,78)];
    menu3.tag = 3;
    [menu3 addTarget:self action:@selector(_addExamApprovel:) forControlEvents:UIControlEventTouchUpInside];
    
    //CGPoint point4 = CGPointMake(center.x - r*cos(M_PI * 3 / 8-M_PI/48), center.y - r*sin(M_PI * 3 / 8-M_PI/48));
    TLMenuButton *menu4 = [TLMenuButton buttonWithTitle:@"加班" imageTitle:@"icon_menu_overtime" center:center color:ColorWithRGB(189,111,221)];
    menu4.tag = 4;
    [menu4 addTarget:self action:@selector(_addExamApprovel:) forControlEvents:UIControlEventTouchUpInside];
    
   // CGPoint point5 = CGPointMake(center.x, center.y - r);
    TLMenuButton *menu5 = [TLMenuButton buttonWithTitle:@"调休" imageTitle:@"icon_menu_dayoff" center:center color:ColorWithRGB(87,211,200)];
    menu5.tag = 5;
    [menu5 addTarget:self action:@selector(_addExamApprovel:) forControlEvents:UIControlEventTouchUpInside];
    
    _menu1 = menu1;
    _menu2 = menu2;
    _menu3 = menu3;
    _menu4 = menu4;
    _menu5 = menu5;
    _menu1.alpha = 0;
    _menu2.alpha = 0;
    _menu3.alpha = 0;
    _menu4.alpha = 0;
    _menu5.alpha = 0;
    
    [kWindow addSubview:menu1];
    [kWindow addSubview:menu2];
    [kWindow addSubview:menu3];
    [kWindow addSubview:menu4];
    [kWindow addSubview:menu5];
    
    [UIView animateWithDuration:0.2 animations:^{
        _menu1.alpha = 1;
        _menu2.alpha = 1;
        _menu3.alpha = 1;
        _menu4.alpha = 1;
        _menu5.alpha = 1;
        _menu1.center = point1;
        _menu2.center = point2;
        _menu3.center = point3;
        _menu4.center = point4;
        _menu5.center = point5;
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.2 animations:^{
        _menu1.center = self.centerPoint;
        _menu2.center = self.centerPoint;
        _menu3.center = self.centerPoint;
        _menu4.center = self.centerPoint;
        _menu5.center = self.centerPoint;
        _menu1.alpha = 0;
        _menu2.alpha = 0;
        _menu3.alpha = 0;
        _menu4.alpha = 0;
        _menu5.alpha = 0;
    } completion:^(BOOL finished) {
        [_menu1 removeFromSuperview];
        [_menu2 removeFromSuperview];
        [_menu3 removeFromSuperview];
        [_menu4 removeFromSuperview];
        [_menu5 removeFromSuperview];
    }];
}

- (void)dismissAtNow{
    [_menu1 removeFromSuperview];
    [_menu2 removeFromSuperview];
    [_menu3 removeFromSuperview];
    [_menu4 removeFromSuperview];
    [_menu5 removeFromSuperview];
}

- (void)_addExamApprovel:(UIButton *)sender{
    //[self dismiss];
    NSLog( @"%@", sender );
    if (self.clickAddButton) {
        self.clickAddButton(sender.tag, [sender valueForKey:@"backgroundColor"] );
    }
}
+ (instancetype)standardMenuView{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instanceMenuView = [[self alloc] init];
    });
    return instanceMenuView;
}
@end

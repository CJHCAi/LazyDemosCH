//
//  ExpressTypeView.m
//  LHand
//
//  Created by wanghui on 2018/1/8.
//  Copyright © 2018年 HandsUp. All rights reserved.
//

#import "ExpressTypeView.h"
#import "UIView+Frame.h"
@interface ExpressTypeView()
@property (weak, nonatomic) IBOutlet UIButton *btn0;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIView *downView;

@end

@implementation ExpressTypeView

+(instancetype)getExpressTypeView{
    ExpressTypeView *view = [[[NSBundle mainBundle]loadNibNamed:@"ExpressTypeView" owner:self options:nil]lastObject];
    view.frame = CGRectMake(0, 0, kScreenWidth, 45);
    [view.btn0 addTarget:view action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view.btn1 addTarget:view action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view.btn2 addTarget:view action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    return view;
}

-(void)btnClick:(UIButton*)btn{
    [UIView animateWithDuration:0.1 animations:^{
        UIColor * selectC = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1];
        UIColor*d =[UIColor colorWithRed:124.0/255.0 green:124.0/255.0 blue:124.0/255.0 alpha:1];
    switch (btn.tag) {
        case 0:
            [self.btn0 setTitleColor:selectC forState:UIControlStateNormal];
            [self.btn1 setTitleColor:d forState:UIControlStateNormal];
            [self.btn2 setTitleColor:d forState:UIControlStateNormal];
            break;
        case 1:
            [self.btn1 setTitleColor:selectC forState:UIControlStateNormal];
            [self.btn0 setTitleColor:d forState:UIControlStateNormal];
            [self.btn2 setTitleColor:d forState:UIControlStateNormal];
            break;
        case 2:
            [self.btn2 setTitleColor:selectC forState:UIControlStateNormal];
            [self.btn1 setTitleColor:d forState:UIControlStateNormal];
            [self.btn0 setTitleColor:d forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
//        <UIButton: 0x157ab64a0; frame = (120 7.5; 80 30); opaque = NO; autoresize = RM+BM; tag = 1; layer = <CALayer: 0x1746248e0>>
//        <UIButton : 0x155914ba0; frame = (138.5 7; 98 30); opaque = NO; autoresize = RM+BM; tag = 1; layer = <CALayer: 0x170839ec0>>

        self.downView.centerX = btn.centerX;

        
    }];
    if ([self.delegete respondsToSelector:@selector(btnClicks:)]) {
        [self.delegete btnClicks:btn.tag];
    }
}
-(void)setType:(int)type{
    _type = type;
    [UIView animateWithDuration:0.1 animations:^{
        UIColor * selectC = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1];
        UIColor*d =[UIColor colorWithRed:124.0/255.0 green:124.0/255.0 blue:124.0/255.0 alpha:1];
        switch (type) {
            case 0:
                [self.btn0 setTitleColor:selectC forState:UIControlStateNormal];
                [self.btn1 setTitleColor:d forState:UIControlStateNormal];
                [self.btn2 setTitleColor:d forState:UIControlStateNormal];
                 self.downView.centerX = self.btn0.centerX;
                break;
            case 1:
                [self.btn1 setTitleColor:selectC forState:UIControlStateNormal];
                [self.btn0 setTitleColor:d forState:UIControlStateNormal];
                [self.btn2 setTitleColor:d forState:UIControlStateNormal];
                self.downView.centerX = self.btn1.centerX;
                break;
            case 2:
                [self.btn2 setTitleColor:selectC forState:UIControlStateNormal];
                [self.btn1 setTitleColor:d forState:UIControlStateNormal];
                [self.btn0 setTitleColor:d forState:UIControlStateNormal];
                self.downView.centerX = self.btn2.centerX;
                break;
            default:
                break;
        }
        
       
        
        
    }];


}

@end

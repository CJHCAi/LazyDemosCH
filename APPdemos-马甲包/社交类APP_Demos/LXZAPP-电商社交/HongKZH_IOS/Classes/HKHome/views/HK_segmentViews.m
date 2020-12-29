//
//  HK_segmentViews.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/9.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_segmentViews.h"
#import "UIButton+LXMImagePosition.h"
@interface HK_segmentViews ()
{
     //按钮宽
    CGFloat btnW ;
    //间距
    CGFloat lineSide;
    //标题大小
    CGFloat font;
}
@property (nonatomic, strong)NSMutableArray *btnArr;
@end

@implementation HK_segmentViews
-(NSMutableArray *)btnArr {
    if (!_btnArr) {
        _btnArr =[[NSMutableArray alloc] init];
    }
    return _btnArr;
}
-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        if (iPhone5) {
            btnW =50;
            lineSide =10;
            font =14;
        }else {
            btnW =60;
            lineSide =10;
            font =16;
        }
        [self setSubViews];
    }
    return self;
}
-(void)setSubViews {
    NSArray *titles =@[@"推荐",@"广告",@"城市",@"自媒体"];
    for (int i=0; i< titles.count; i++) {
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake((btnW+lineSide)*i,0,btnW,44);
        [btn setTitleColor:[UIColor colorFromHexString:@"999999"] forState:UIControlStateNormal];
        btn.titleLabel.font =[UIFont systemFontOfSize:font];
        if (i==0) {
            [btn setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
//            [btn setImage:[UIImage imageNamed:@"lk_hb"] forState:UIControlStateNormal];
//            [btn setImagePosition:1 spacing:4];
            self.sliderV =[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn.frame)+10,CGRectGetMaxY(btn.frame)-10,CGRectGetWidth(btn.frame)-15,2.5)];
            self.sliderV.layer.cornerRadius = 1.25;
            self.sliderV.layer.masksToBounds = YES;
            [self addSubview:self.sliderV];
            self.sliderV.backgroundColor = keyColor;
            btn.titleLabel.font =[UIFont boldSystemFontOfSize:font];
        }
         btn.tag = 1000+i;
        [self.btnArr addObject:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}
-(void)lookhistory {
    if (self.delegete  && [self.delegete respondsToSelector:@selector(goHistory)]) {
        [self.delegete goHistory];
    }
}
//设置UI
-(void)setSegCongigueWithIndex:(NSInteger)index {
    UIButton * sender =[self.btnArr objectAtIndex:index];
    for (UIButton * b in self.btnArr) {
        [b setTitleColor:[UIColor colorFromHexString:@"999999"] forState:UIControlStateNormal];
    }
    [sender setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.25 animations:^{
        self.sliderV.frame =CGRectMake(CGRectGetMinX(sender.frame)+10,CGRectGetMaxY(sender.frame)-10,CGRectGetWidth(sender.frame)-15,2.5);
    }];
}
-(void)btnClick:(UIButton *)sender {
    for (UIButton * b in self.btnArr) {
        [b setTitleColor:[UIColor colorFromHexString:@"999999"] forState:UIControlStateNormal];
         b.titleLabel.font =[UIFont systemFontOfSize:font];
    }
    [sender setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
     sender.titleLabel.font =[UIFont boldSystemFontOfSize:font];
    [UIView animateWithDuration:0.25 animations:^{
         self.sliderV.frame =CGRectMake(CGRectGetMinX(sender.frame)+10,CGRectGetMaxY(sender.frame)-10,CGRectGetWidth(sender.frame)-15,2.5);
    }];
    if (self.delegete  && [self.delegete respondsToSelector:@selector(clickSegIndex:)]) {
        [self.delegete clickSegIndex:sender.tag-1000];
    }
}
@end

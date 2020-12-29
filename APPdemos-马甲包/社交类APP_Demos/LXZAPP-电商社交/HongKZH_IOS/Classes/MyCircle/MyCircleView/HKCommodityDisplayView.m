//
//  HKCommodityDisplayView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCommodityDisplayView.h"
#import "UIButton+ZSYYWebImage.h"
@interface HKCommodityDisplayView()
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UILabel *label;
@end

@implementation HKCommodityDisplayView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(15);
        make.height.mas_equalTo(15);
    }];
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(70);
        make.top.equalTo(self.label.mas_bottom).offset(20);
    }];
}

-(void)setImageArray:(NSArray*)imageArray imagenum:(int)num{
    for (UIView * view  in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
   // self.scrollView.contentSize = CGSizeMake((num+1)*70+5*(num)-30, 70);
     self.scrollView.contentSize = CGSizeMake((num+1)*70+5*(num)+30, 70);

    int imageCount = (int)imageArray.count;
    for (int i = 0; i<imageArray.count; i++) {
        NSString*imageStr = imageArray[i];
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = i ;
        [btn hk_setBackgroundImageWithURL:imageStr forState:0 placeholder:kPlaceholderImage];
        [self.scrollView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView).offset(15+75*i);
            make.top.equalTo(self.scrollView);
            make.width.height.mas_equalTo(70);
        }];
        [btn addTarget:self action:@selector(chooseGoods) forControlEvents:UIControlEventTouchUpInside];
    }
    //展位和 选出的商品. 3 2
  //可以在现有的基础上增加的商品..
    // 8 - 4
    NSInteger surplus = num - imageCount;
    if (surplus>0) {
        for (int i = 0; i<surplus; i++) {
            UIButton *btn = [[UIButton alloc]init];
            btn.tag = i+ imageCount;
            [btn setBackgroundImage:[UIImage imageNamed:@"fbsp2jiat"] forState:0];
           [self.scrollView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scrollView).offset(15+75*(i+imageCount));
                make.top.equalTo(self.scrollView);
                make.width.height.mas_equalTo(70);
            }];
            //btn.backgroundColor =[UIColor blueColor];
           //选择商品..
            [btn addTarget:self action:@selector(chooseGoods) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    UIButton *btn = [[UIButton alloc]init];
    btn.tag = num;
    [btn setBackgroundImage:[UIImage imageNamed:@"fabugmzw"] forState:0];
    btn.titleLabel.font =PingFangSCMedium14;
    [btn setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] forState:0];
    [self.scrollView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(15+75*(num));
        make.top.equalTo(self.scrollView);
        make.width.height.mas_equalTo(70);
    }];
    //购买展位
    [btn addTarget:self action:@selector(shopBooth) forControlEvents:UIControlEventTouchUpInside];
}
-(void)shopBooth {
    if (self.delegete && [self.delegete respondsToSelector:@selector(purchase)]) {
        [self.delegete purchase];
    }
}
-(void)chooseGoods {
    if (self.delegete && [self.delegete respondsToSelector:@selector(selectGoods)]) {
        [self.delegete selectGoods];
    }
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        _scrollView = scrollView;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.bounces = NO;
    }
    return _scrollView;
}
-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.text = @"展示商品";
        _label.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        _label.font = [UIFont systemFontOfSize:15];
    }
    return _label;
}
@end

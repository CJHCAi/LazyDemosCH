//
//  HKHeadShowView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHeadShowView.h"
#import "UIButton+ZSYYWebImage.h"
#import "ZSUserHeadBtn.h"
#import "HKMyCircleMemberModel.h"
@interface HKHeadShowView()
@property (nonatomic, strong)UIScrollView *scrollView;
@end

@implementation HKHeadShowView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
-(void)setImageArray:(NSMutableArray *)imageArray{
    _imageArray = imageArray;
    
    self.scrollView.contentSize = CGSizeMake(48*imageArray.count+15*(imageArray.count-1)+40, 67);
    CGFloat mark = 20;
    CGFloat wAndH = 48;
    CGFloat r = 15;
    for (int i = 0 ; i<imageArray.count; i++) {
        ZSUserHeadBtn *btn = [[ZSUserHeadBtn alloc]init];
        [btn addTarget:self action:@selector(headClick) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self.scrollView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView).offset(mark+i*(wAndH+r));
            make.top.equalTo(self.scrollView);
            make.width.height.mas_equalTo(wAndH);
        }];
        HKMyCircleMemberModel*imaStrM = imageArray[i];
        [btn hk_setBackgroundImageWithURL:imaStrM.headImg forState:0 placeholder:kPlaceholderImage];
        
        UILabel*label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        label.font = [UIFont systemFontOfSize:12];
        [self.scrollView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btn.mas_bottom).offset(7);
            make.centerX.equalTo(btn);
            make.height.mas_offset(12);
        }];
        label.text = imaStrM.uName;
    }
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        _scrollView = scrollView;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.bounces = NO;
        scrollView.userInteractionEnabled = YES;
    }
    return _scrollView;
}
-(void)headClick {
    if (self.delegete && [self.delegete respondsToSelector:@selector(clickHead)]) {
        [self.delegete clickHead];
    }
}
@end

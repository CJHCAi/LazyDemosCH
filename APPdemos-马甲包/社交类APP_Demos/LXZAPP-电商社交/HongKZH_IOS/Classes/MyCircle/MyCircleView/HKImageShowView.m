//
//  HKImageShowView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKImageShowView.h"
#import "UIButton+ZSYYWebImage.h"
@interface HKImageShowView()
@property (nonatomic, strong)UIScrollView *scrollView;
@end

@implementation HKImageShowView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
-(void)setImageArray:(NSMutableArray *)imageArray{
    _imageArray = imageArray;
    
    self.scrollView.contentSize = CGSizeMake(70*imageArray.count+5*(imageArray.count-1)+30, 70);
    CGFloat mark = 15;
    CGFloat wAndH = 70;
    CGFloat r = 5;
    for (int i = 0 ; i<imageArray.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = i;
        [btn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView).offset(mark+i*(wAndH+r));
            make.top.equalTo(self.scrollView);
            make.width.height.mas_equalTo(70);
        }];
        NSString*imaStr = imageArray[i];
        [btn hk_setBackgroundImageWithURL:imaStr forState:0 placeholder:kPlaceholderImage];
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
-(void)imageClick:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(gotoShopping:)]) {
        [self.delegate gotoShopping:sender.tag];
    }
}
@end

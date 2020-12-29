//
//  HKCtyItemListView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/14.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCtyItemListView.h"
#import "HKCityItemView.h"
#import "CategoryTop10ListRespone.h"
#import "HKSelfMediaHotItemView.h"
@interface HKCtyItemListView()<HKCityItemViewDelegate>
@property (nonatomic, strong)UIScrollView *scrollView;
@end

@implementation HKCtyItemListView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
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
-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat w = (kScreenWidth-10)/3;
    self.scrollView.contentSize = CGSizeMake(w*dataArray.count, 155);
    for (int i = 0; i<dataArray.count; i++) {
        HKCityItemView*item = [[HKCityItemView alloc]init];
        item.tag = i;
        CityMainHostModel*hostM = dataArray[i];
        item.model = hostM;
        [self.scrollView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView).offset(i*w);
            make.top.equalTo(self.scrollView);
            make.width.mas_equalTo(w);
            make.height.mas_equalTo((w-10)*3/4+74);
        }];
        UIButton*btn = [[UIButton alloc]init];
        [self.scrollView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView).offset(i*w);
            make.top.equalTo(self.scrollView);
            make.width.mas_equalTo(w);
            make.height.mas_equalTo(155);
        }];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        item.delegate = self;
    }
}
-(void)setSelfMediaArray:(NSArray *)selfMediaArray{
    _selfMediaArray = selfMediaArray;

    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat w = (kScreenWidth-10)/3;
    self.scrollView.contentSize = CGSizeMake(w*selfMediaArray.count, 155);
    for (int i = 0; i<selfMediaArray.count; i++) {
        HKSelfMediaHotItemView*item = [[HKSelfMediaHotItemView alloc]init];
        item.tag = i;
        CategoryTop10ListModel*hostM = selfMediaArray[i];
        item.model = hostM;
        if (i==0 || i==1 ||i==2) {
            item.rankView.hidden = NO;
            item.rankView.image =[UIImage imageNamed:[NSString stringWithFormat:@"selfMedia_top%d",i+1]];
        }else {
            item.rankView.hidden = YES;
        }
        [self.scrollView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView).offset(i*w);
            make.top.equalTo(self.scrollView);
            make.width.mas_equalTo(w);
            make.height.mas_equalTo(w-10);
        }];
        UIButton*btn = [[UIButton alloc]init];
        [self.scrollView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView).offset(i*w);
            make.top.equalTo(self.scrollView);
            make.width.mas_equalTo(w);
            make.height.mas_equalTo(w - 10);
        }];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)btnClick:(UIButton*)btn{
    
    if ([self.delegate respondsToSelector:@selector(itemClick:)]) {
        [self.delegate itemClick:btn.tag];
    }
}
-(void)clickItem:(NSInteger)index{
    
    if ([self.delegate respondsToSelector:@selector(itemClick:)]) {
        [self.delegate itemClick:index];
    }
}
@end

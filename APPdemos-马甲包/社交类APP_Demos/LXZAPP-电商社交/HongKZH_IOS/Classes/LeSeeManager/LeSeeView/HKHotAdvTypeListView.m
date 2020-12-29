//
//  HKHotAdvTypeListView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHotAdvTypeListView.h"
#import "EnterpriseHotAdvTypeListRedpone.h"
#import "HKHotAdvTypeItem.h"
@interface HKHotAdvTypeListView()<HKHotAdvTypeItemDelegate>
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)NSMutableArray *itemArray;
@end

@implementation HKHotAdvTypeListView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
-(void)setModel:(EnterpriseHotAdvTypeListRedpone *)model{
    _model = model;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat w = kScreenWidth*0.25;
    for (int i = 0; i<model.data.count; i++) {
        HKHotAdvTypeItem*item = [[HKHotAdvTypeItem alloc]init];
        item.delegate = self;
        item.tag = i;
       
        [self.scrollView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView).offset(i*w);
            make.top.equalTo(self.scrollView);
            make.width.mas_equalTo(w);
            make.height.mas_equalTo(86);
        }];
        EnterpriseHotAdvTypeListModel*modelItem = model.data[i];
        if (i == model.selectIndex) {
            item.isSelect = YES;
        }else{
            item.isSelect = NO;
        }
        item.model = modelItem;
        [self.itemArray addObject:item];
    }
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];;
        //        scrollView.delegate = self;;
        //横竖两种滚轮都不显示
        scrollView.showsVerticalScrollIndicator = NO;;
        scrollView.showsHorizontalScrollIndicator = NO;;
        //需要分页
        scrollView.pagingEnabled = YES;;
        scrollView.bounces = NO;
        _scrollView = scrollView;;
    }
    return _scrollView;
}
-(void)clickWithTag:(NSInteger)tag{
    
    for (NSInteger i= 0;i< self.itemArray.count;i++) {
        HKHotAdvTypeItem*item = self.itemArray[i];
        if (i==tag) {
            item.isSelect = YES;
        }else{
            item.isSelect = NO;
        }
    }
    self.model.selectIndex = tag;
    if ([self.delegate respondsToSelector:@selector(clickType:)]) {
        [self.delegate clickType:tag];
    }
}
-(NSMutableArray *)itemArray{
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}
@end

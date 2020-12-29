//
//  HKHostView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHostView.h"
#import "HKHostPageView.h"
@interface HKHostView()<HKHostPageViewDelegate>
@property (nonatomic, strong)UIScrollView *scrollView;

@end

@implementation HKHostView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

+(NSMutableArray*)getDataWithArray:(NSArray*)dataArray{
    NSMutableArray *sectionArray = [NSMutableArray array];
    NSMutableArray*fristArray = [NSMutableArray arrayWithCapacity:4];
    [sectionArray addObject:fristArray];
    for (NSObject*obj in dataArray) {
        NSMutableArray*curA = sectionArray.lastObject;
        if (curA.count>=4) {
            NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:4];
            [newArray addObject:obj];
            [sectionArray addObject:newArray];
        }else{
            [curA addObject:obj];
        }
    }
    return sectionArray;
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
- (NSMutableArray *)questionArray
{
    if(_questionArray == nil)
    {
        _questionArray = [ NSMutableArray array];
    }
    return _questionArray;
}
-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.questionArray = [HKHostView getDataWithArray:dataArray];
    CGFloat w = kScreenWidth-30;
    for (int i=0; i<self.questionArray.count; i++) {
        CGFloat x = 15+ i*(5+w);
        HKHostPageView*pageView = [[HKHostPageView alloc]init];
        pageView.tag = i;
        pageView.delegate = self;
        [self.scrollView addSubview:pageView];
        [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView).offset(x);
            make.top.equalTo(self.scrollView);
            make.width.mas_equalTo(w);
            make.height.mas_offset(w*97/170+39);
        }];
        pageView.array = self.questionArray[i];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         self.scrollView.contentSize = CGSizeMake(kScreenWidth*self.questionArray.count-30, 200);
    });
   
}
-(void)clickHot:(NSInteger)tag{
    if ([self.delegate respondsToSelector:@selector(toCellHot:)]) {
        [self.delegate toCellHot:tag];
    }
}
@end

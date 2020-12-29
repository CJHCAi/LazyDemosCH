//
//  HKBasePictureBrowserView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/7.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBasePictureBrowserView.h"
#import "UIButton+ZSYYWebImage.h"
@interface HKBasePictureBrowserView()
@property (nonatomic, strong)UIScrollView *scrllView;
@end

@implementation HKBasePictureBrowserView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self addSubview:self.scrllView];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.scrllView];
    }
    return self;
}
@synthesize questionArray = _questionArray;
-(void)setQuestionArray:(NSMutableArray *)questionArray{
    _questionArray = questionArray;
    [self.scrllView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    CGFloat w = self.bounds.size.height;
    if (questionArray.count>0) {
        self.scrllView.contentSize =  CGSizeMake(w*questionArray.count+5*questionArray.count-1, self.bounds.size.height);
        for (int i = 0; i<questionArray.count; i++) {
            UIButton*btn = [[UIButton alloc]init];
            [self.scrllView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.width.mas_equalTo(w);
                make.top.equalTo(self.scrllView); make.left.equalTo(self.scrllView).offset(i*(w+5));
            }];
            [btn hk_setBackgroundImageWithURL:questionArray[i] forState:0 placeholder:kPlaceholderImage];
        }
        
        
    }
    
    
}
-(UIScrollView *)scrllView{
    if (!_scrllView) {
        _scrllView = [[UIScrollView alloc]init];
        _scrllView.showsHorizontalScrollIndicator = NO;
        _scrllView.showsVerticalScrollIndicator = NO;
        _scrllView.bounces = NO;
    }
    return _scrllView;
}
- (NSMutableArray *)questionArray
{
    if(_questionArray == nil)
    {
        _questionArray = [ NSMutableArray array];
    }
    return _questionArray;
}
@end

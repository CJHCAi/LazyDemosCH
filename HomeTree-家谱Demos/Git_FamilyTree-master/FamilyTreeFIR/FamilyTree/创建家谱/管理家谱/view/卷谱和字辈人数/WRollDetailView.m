//
//  WRollDetailView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/22.
//  Copyright © 2016年 王子豪. All rights reserved.
//
enum {
    BTNTAGRead,
    BTNTAGManager
};
#import "WRollDetailView.h"
@interface WRollDetailView()
{
    NSMutableArray *_leftArr;
    NSMutableArray *_rightArr;
}
/**背景*/
@property (nonatomic,strong) UIView *backView;
/**背景滚动*/
@property (nonatomic,strong) UIScrollView *backScrollView;

@end
@implementation WRollDetailView

- (instancetype)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.backView];
        self.userInteractionEnabled = true;
        [self addSubview:self.backScrollView];
        
        [self initData];
        [self initUI];
    }
    return self;
}

-(void)updateUI{
    
    WJPPersonZBNumberModel *model = [WJPPersonZBNumberModel sharedWJPPersonZBNumberModel];
    
    NSInteger personNumber = 0;
    
    for (int idx = 0; idx<model.datalist.count; idx++) {
        _leftArr[idx+2] = [NSString stringWithFormat:@"%@：",model.datalist[idx].zb];
        _rightArr[idx+2] = [NSString stringWithFormat:@"%ld",(long)model.datalist[idx].cnt];
        
        personNumber += model.datalist[idx].cnt;
    }
    _rightArr[0] = [NSString stringWithFormat:@"%ld",(long)personNumber];
    
    [self removeAllSubviews];
    [self.backScrollView removeAllSubviews];
    [self addSubview:self.backView];
    [self addSubview:self.backScrollView];
    CGFloat sizeHeight = _leftArr.count>7?16+_leftArr.count*45:self.bounds.size.height/AdaptationWidth();
    self.backScrollView.contentSize = AdaptationSize(225, sizeHeight);
    [self initUI];
    
}
#pragma mark *** 初始化数据 ***
-(void)initData{
    _leftArr = [@[@"人数：",@"字辈：",@"",@"",@"",@"",@""] mutableCopy];
    
    _rightArr = [@[@"",@"",@"",@"",@"",@"",@""] mutableCopy];
}

#pragma mark *** events ***
-(void)respondsTolefTwBtn:(UIButton *)sender{
    switch (sender.tag) {
        case BTNTAGRead:
        {
            WDetailManagerViewController *detaiVc = [[WDetailManagerViewController alloc] initWithTitle:@"管理卷谱" image:nil];
            [[self viewController].navigationController pushViewController:detaiVc animated:YES];
        }
            break;
        case BTNTAGManager:
        {
            WDetailManagerViewController *detaiVc = [[WDetailManagerViewController alloc] initWithTitle:@"管理卷谱" image:nil];
            [[self viewController].navigationController pushViewController:detaiVc animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark *** 初始化界面 ***
-(void)initUI{
    
    //具体信息
    for (int idx = 0; idx<_leftArr.count; idx++) {
        NSInteger length = ((NSString *)_leftArr[idx]).length;
        UILabel *leftLB = [[UILabel alloc] initWithFrame:AdaptationFrame(16, 16+idx*45, length*27, 45)];
        leftLB.font = MFont(26*AdaptationWidth());
        leftLB.text = _leftArr[idx];
        NSInteger length2 = ((NSString *)_rightArr[idx]).length;
        UILabel *rightLb = [[UILabel alloc] initWithFrame:AdaptationFrame(CGRectXW(leftLB)/AdaptationWidth(), 16+idx*45, length2*50, leftLB.frame.size.height/AdaptationWidth())];
        rightLb.text = [NSString stringWithFormat:@"%@人",_rightArr[idx]];
        rightLb.font = leftLB.font;
        
        [self.backScrollView addSubview:leftLB];
        [self.backScrollView addSubview:rightLb];
        
    }
    
    //左边两个btn
#warning 去掉了管理
//    NSArray *btnTitle = @[@"查阅",@"管理"];
        NSArray *btnTitle = @[@"查阅"];

    NSArray *colorArr = @[LH_RGBCOLOR(217, 169, 129),LH_RGBCOLOR(90, 110, 115)];
    for (int idx = 0; idx<btnTitle.count; idx++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:AdaptationFrame(0, 24+167*idx, 47, 134)];
        [btn setTitle:btnTitle[idx] forState:0];
        btn.tag = idx;
        btn.titleLabel.font = WFont(32);
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        btn.titleLabel.numberOfLines = 0;
        btn.backgroundColor = colorArr[idx];
        btn.layer.cornerRadius = 2;
        btn.clipsToBounds = YES;
        [btn addTarget:self action:@selector(respondsTolefTwBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

#pragma mark *** getters ***
-(UIView *)backView{
    if (!_backView) {
        //背景加边框
        UIView *bakView = [[UIView alloc] initWithFrame:CGRectMake(46*AdaptationWidth(), 0, 225*AdaptationWidth(), self.bounds.size.height)];
        bakView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        bakView.layer.borderWidth = 1.0f;
        bakView.layer.borderColor = LH_RGBCOLOR(234, 221, 200).CGColor;
        
        _backView = bakView;
        
    }
    return _backView;
}
-(UIScrollView *)backScrollView{
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(46*AdaptationWidth(), 0, 225*AdaptationWidth(), self.bounds.size.height)];
        _backScrollView.showsVerticalScrollIndicator = false;
        _backScrollView.showsHorizontalScrollIndicator = false;
        _backScrollView.backgroundColor = [UIColor clearColor];
//        CGFloat sizeHeight = _leftArr.count>5?_leftArr.count:45+5*90;
//        _backScrollView.contentSize = AdaptationSize(225, 1500);
    }
    return _backScrollView;
}
@end

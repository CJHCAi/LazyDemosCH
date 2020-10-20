//
//  SXTDetailsTopImageView.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/23.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTDetailsTopImageView.h"
#import "SDCycleScrollView.h"//轮播图

@interface SXTDetailsTopImageView()

@property (strong, nonatomic)   SDCycleScrollView *headImageView;              /** 广告轮播 */
@property (strong, nonatomic)   UILabel *buyNumLabel;              /** 已经多少人购买 */
@end

@implementation SXTDetailsTopImageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.headImageView];
        [self addSubview:self.buyNumLabel];
        __weak typeof (self) weakSelf = self;
        [_buyNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(90, 22));
            make.bottom.equalTo(weakSelf.mas_bottom).offset(-30);
            make.right.equalTo(weakSelf.mas_right).offset(11);
        }];
    }
    return self;
}

- (void)setImageArray:(NSArray *)imageArray{
    _headImageView.imageURLStringsGroup = imageArray;
}

- (void)setBuyNum:(NSString *)buyNum{
    _buyNumLabel.text = buyNum;
}

- (SDCycleScrollView *)headImageView{
    if (!_headImageView) {
        _headImageView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 380) delegate:nil placeholderImage:[UIImage imageNamed:@"图标"]];
        _headImageView.backgroundColor = [UIColor orangeColor];
        _headImageView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _headImageView.currentPageDotColor = [UIColor whiteColor]; // 自
    }
    return _headImageView;
}

- (UILabel *)buyNumLabel{
    if (!_buyNumLabel) {
        _buyNumLabel = [[UILabel alloc]init];
        _buyNumLabel.text = @"1000人已购买";
        _buyNumLabel.backgroundColor = RGB(230, 51, 37);
        _buyNumLabel.textColor = [UIColor whiteColor];
        _buyNumLabel.layer.masksToBounds = YES;
        _buyNumLabel.layer.cornerRadius = 11.0;
        _buyNumLabel.textAlignment = NSTextAlignmentCenter;
        _buyNumLabel.font = [UIFont systemFontOfSize:11.0];
    }
    return _buyNumLabel;
}

@end










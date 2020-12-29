//
//  HKRecommendHeadCollectionViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/5.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKRecommendHeadCollectionViewCell.h"
#import "SelfMediaHeadView.h"
#import "HKSowingRespone.h"
#import "HKSelfMedioheadRespone.h"
#import "CategoryTop10ListRespone.h"
@interface HKRecommendHeadCollectionViewCell()<SelfMediaHeadViewDelegate>
@property (nonatomic, strong)SelfMediaHeadView *mediaHeadView;
@end

@implementation HKRecommendHeadCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       [self.contentView addSubview:self.mediaHeadView];
    }
    return self;
}
-(void)clickItme:(CategoryTop10ListModel *)model{
    if ([self.delegate respondsToSelector:@selector(selectTop3:)]) {
        [self.delegate selectTop3:model];
    }
}
-(SelfMediaHeadView *)mediaHeadView{
    if (!_mediaHeadView) {
        UIImage*image = [UIImage imageNamed:@"zmt_rdph"];
        _mediaHeadView = [[SelfMediaHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, ((kScreenWidth-10)/3-10+20+20+20+image.size.height)+kScreenWidth/3)];
        _mediaHeadView.delegate = self;
        _mediaHeadView.isHideDown = YES;
    }
    return _mediaHeadView;
}
-(void)setRespone:(HKSelfMedioheadRespone *)respone{
    _respone = respone;
    HKSowingRespone*sowM = [[HKSowingRespone alloc]init];
    sowM.data = respone.data.carousels;
    self.mediaHeadView.sowM = sowM;
    CategoryTop10ListRespone*top10 = [[CategoryTop10ListRespone alloc]init];
    top10.data = respone.data.top;
    self.mediaHeadView.top10 =  top10;
}
@end

//
//  HKSelfMeidaVodeoTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSelfMeidaVodeoTableViewCell.h"
#import "HKSelfMeidaVodeoViewModel.h"
#import "GetMediaAdvAdvByIdRespone.h"
#import "HKBaseViewModel.h"
#import "HKUploadRespone.h"
#import "UIView+Extend.h"
#import "WHFullAliyunVideoView.h"
#import "UIImageView+HKWeb.h"
@interface HKSelfMeidaVodeoTableViewCell()<WHFullAliyunVideoViewDelegate>
@property (nonatomic, strong)WHFullAliyunVideoView *aliyunPlayView;
@property(nonatomic, assign) BOOL isHasData;
@end

@implementation HKSelfMeidaVodeoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.iconView.userInteractionEnabled = YES;
}
-(void)addVideo:(NSString*)urlString{
    [self.contentView addSubview:self.aliyunPlayView];
    [self.aliyunPlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
}
-(void)setDataM:(GetMediaAdvAdvByIdRespone *)dataM{
    _dataM = dataM;
    self.aliyunPlayView.dataM = dataM;
}
-(void)setModel:(SelfMediaModelList *)model{
    _model = model;
    [self.iconView  hk_sd_setImageWithURL:model.coverImgSrc placeholderImage:kPlaceholderImage];
    self.aliyunPlayView.model = model;
}
-(void)setStaue:(HKPalyStaue)staue{
    _staue = staue;
    self.aliyunPlayView.staue = staue;
    switch (staue) {
        case HKPalyStaue_play:
            {
                [self.aliyunPlayView playWithVid:self.dataM.data.imgSrc];
            }
            break;
        case HKPalyStaue_stop:
        {
            [self.aliyunPlayView stop];
        }
            break;
        case HKPalyStaue_End:
        {
            [self.aliyunPlayView stop];
        }
            break;
        case HKPalyStaue_close:
        {
            [self.aliyunPlayView reset];
        }
            break;
        case HKPalyStaue_resume:
        {
            [self.aliyunPlayView resume];
        }
            break;
        default:
            break;
    }
  
}
- (void)toolClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(showtoolViewWIthIndex:andIndexPath:)]) {
        [self.delegate showtoolViewWIthIndex:sender.tag andIndexPath:self.indexpath];
    }
}
-(WHFullAliyunVideoView *)aliyunPlayView{
    if (!_aliyunPlayView) {
        _aliyunPlayView = [[WHFullAliyunVideoView alloc]init];
        _aliyunPlayView.delegate = self;
    }
    return _aliyunPlayView;
}
@end

//
//  WHFullAliyunVideoView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "WHAliyunSeniorVideoView.h"
#import "SelfMediaRespone.h"
#import "GetMediaAdvAdvByIdRespone.h"
@protocol WHFullAliyunVideoViewDelegate <NSObject>
@optional
- (void)toolClick:(UIButton *)sender;
-(void)playAliyunVodPlayerEventFinish;
-(void)playSurplusTime:(NSInteger)surplusTime;
-(void)more;
-(void)maxPlayClick:(HKPalyStaue)staue;
@end
@interface WHFullAliyunVideoView : WHAliyunSeniorVideoView
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allTime;
@property (weak, nonatomic) IBOutlet UILabel *playIngTime;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *reward;
@property (weak, nonatomic) IBOutlet UILabel *save;
@property (weak, nonatomic) IBOutlet UILabel *znum;
@property (weak, nonatomic) IBOutlet UILabel *commitNum;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *praiseIcon;
@property (weak, nonatomic) IBOutlet UILabel *totleTime;
@property (nonatomic, strong)GetMediaAdvAdvByIdRespone *dataM;
@property (nonatomic, strong)SelfMediaModelList *model;
@property (weak, nonatomic) IBOutlet UIImageView *saveIcon;
@property (nonatomic,weak) id<WHFullAliyunVideoViewDelegate> delegate;

@property (nonatomic,assign) int type;

@property (nonatomic, strong)UIView *superView;
@end

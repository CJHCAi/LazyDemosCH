//
//  HKLuckyBurstListTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLuckyBurstListTableViewCell.h"
#import "HKLuckyBurstListRespone.h"
#import "UIImageView+HKWeb.h"
#import "HKluckyBurstDetailRespone.h"
#import "NSDate+Extend.h"
#import "HKDiscountView.h"
@interface HKLuckyBurstListTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *Discount;
@property (weak, nonatomic) IBOutlet UILabel *titleVIew;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *timeM;
@property (weak, nonatomic) IBOutlet UILabel *timeS;
@property (weak, nonatomic) IBOutlet UIImageView *clickImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disCountW;
@property (weak, nonatomic) IBOutlet UIView *timeView;

@property (weak, nonatomic) IBOutlet UIImageView *timeTitleIcon;
@property (weak, nonatomic) IBOutlet HKDiscountView *discountView;
@property (nonatomic, strong)NSTimer *timer;
@end

@implementation HKLuckyBurstListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoInfo)];
    self.clickImageView.userInteractionEnabled = YES;
    [self.clickImageView addGestureRecognizer:tap];
    self.contentView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
    self.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
    UIImage*image  = [UIImage imageNamed:@"xrzx_zk"];
    self.disCountW.constant = image.size.width;
    // Initialization code
}
-(void)gotoInfo{
    if ([self.delegate respondsToSelector:@selector(toInfoVc)]) {
        [self.delegate toInfoVc];
    }
}
-(void)setRespone:(HKLuckyBurstListRespone *)respone{
    _respone = respone;
    [self endTimer];
    [self.iconView hk_sd_setImageWithURL:respone.data.imgSrc placeholderImage:kPlaceholderImage];
    self.titleVIew.text = respone.data.title;
    self.price.text = [NSString stringWithFormat:@"商品原价：%ld",respone.data.pintegral];
    if (respone.data.sortDate == 0) {
        self.timeView.hidden = NO;
        self.timeTitleIcon.image = [UIImage imageNamed:@"bkms_jljs"];
        [self starTimer];
    }else if(respone.data.sortDate>0){
        self.timeView.hidden = YES;
        self.timeTitle.hidden = NO;//bkms_jljs_01
        self.timeTitle.text = @"即将开始";
        self.timeTitleIcon.image = [UIImage imageNamed:@"bkms_jljs_01"];
    }else{
        self.timeView.hidden = YES;
        self.timeTitle.hidden = NO;
        self.timeTitle.text = @"已经结束";
        self.timeTitleIcon.image = [UIImage imageNamed:@"bkms_jljs_01"];
    }
    self.discountView.discount = respone.data.discount;
}
-(void)setModel:(HKluckyBurstDetailRespone *)model{
    _model = model;
    [self.iconView hk_sd_setImageWithURL:model.data.imgSrc placeholderImage:kPlaceholderImage];
    self.titleVIew.text = model.data.title;
    self.price.text = [NSString stringWithFormat:@"商品原价：%ld",model.data.pintegral];
   
    if (_model.data.sortDate == 0) {
        self.timeTitleIcon.image = [UIImage imageNamed:@"bkms_jljs"];
        self.timeView.hidden = NO;
        [self starTimer];
    }else if(_model.data.sortDate>0){
        self.timeView.hidden = YES;
        self.timeTitle.hidden = NO;
        self.timeTitle.text = @"即将开始";
        self.timeTitleIcon.image = [UIImage imageNamed:@"bkms_jljs_01"];
    }else{
        self.timeView.hidden = YES;
        self.timeTitle.hidden = NO;
        self.timeTitle.text = @"已经结束";
        self.timeTitleIcon.image = [UIImage imageNamed:@"bkms_jljs_01"];
    }
    self.discountView.discount = model.data.discount;
}
-(void)countDown{
    NSInteger difference = 0;
    
    if (_model) {
        self.model.data.currentTimeStamp++;
        difference = self.model.data.endDate*60*60-self.model.data.currentTimeStamp;
        
    }else{
        self.respone.data.currentTimeStamp++;
        difference = self.respone.data.endDate*60*60-self.respone.data.currentTimeStamp;
    }
    
    if (difference>0) {
        self.timeTitleIcon.image = [UIImage imageNamed:@"bkms_jljs"];
        [NSDate getdifferenceWithTime:difference back:^(NSString *hour, NSString *minute, NSString *second) {
            self.timeM.text = minute;
            self.timeS.text = second;
        }];
    }else{
        [self endTimer];
        self.timeView.hidden = YES;
        self.timeTitle.hidden = NO;
        self.timeTitle.text = @"已经结束";
        self.timeTitleIcon.image = [UIImage imageNamed:@"bkms_jljs_01"];
        if([self.delegate respondsToSelector:@selector(burstEnd)]){
            [self.delegate burstEnd];
        }
    }
  
}
-(void)starTimer{
    [self endTimer];
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void)endTimer{
    [_timer invalidate];
    _timer = nil;
}
@end

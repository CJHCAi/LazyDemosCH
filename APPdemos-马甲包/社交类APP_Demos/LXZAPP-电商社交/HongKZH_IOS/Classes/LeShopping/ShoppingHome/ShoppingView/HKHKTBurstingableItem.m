//
//  HKHKTBurstingableItem.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHKTBurstingableItem.h"
#import "UIImageView+HKWeb.h"
#import "NSDate+Extend.h"
#import "UIImage+YY.h"
#import "HKDiscountView.h"
@interface HKHKTBurstingableItem()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *discountIntegral;
@property (weak, nonatomic) IBOutlet UILabel *ntegral;
@property (weak, nonatomic) IBOutlet UIButton *hour;
@property (weak, nonatomic) IBOutlet UIButton *minute;
@property (weak, nonatomic) IBOutlet UIButton *second;
@property (weak, nonatomic) IBOutlet HKDiscountView *discountView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disCountW;
@property (nonatomic, strong)NSTimer *timer;
@property (weak, nonatomic) IBOutlet UILabel *staueLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end

@implementation HKHKTBurstingableItem

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage*image = [UIImage createImageWithColor:[UIColor colorFromHexString:@"565F64"] size:CGSizeMake(17, 17)];
    image = [image zsyy_imageByRoundCornerRadius:3];
    [self.hour setBackgroundImage:image forState:0];
    [self.minute setBackgroundImage:image forState:0];
    [self.second setBackgroundImage:image forState:0];
    
    
    UIImage*images  = [UIImage imageNamed:@"xrzx_zk"];
    self.disCountW.constant = images.size.width;
    // Initialization code
    self.discountIntegral.font = BoldFont18;
    self.stateLabel.textColor =[UIColor colorFromHexString:@"999999"];
    
    
}
-(void)setProductsM:(HKLeShopHomeLuckyvouchers *)productsM{
    _productsM = productsM;
    [self.iconView hk_sd_setImageWithURL:productsM.imgSrc placeholderImage:kPlaceholderImage];
    self.name.text = productsM.title;
    self.discountIntegral.text = [NSString stringWithFormat:@"¥%ld",productsM.discountIntegral];
    self.ntegral.text = [NSString stringWithFormat:@"¥%.2f",productsM.integral];
    [_timer invalidate];
    _timer = nil;
    if (productsM.difference>0) {
        self.staueLabel.text = @"即将开始";
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(createPersonLayer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }else if(productsM.difference<0){
        self.staueLabel.text = @"已经结束";
        [self.hour setTitle:@"00" forState:0];
        [self.minute setTitle:@"00" forState:0];
        [self.second setTitle:@"00" forState:0];
    }else{
        self.staueLabel.text = @"即时抢购";
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(createPersonLayer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    self.discountView.discount = productsM.discount;
}
-(void)createPersonLayer{
    
    if (_productsM.difference <0) {
        _productsM.startDifference --;
        [NSDate getdifferenceWithTime:_productsM.startDifference back:^(NSString *hour, NSString *minute, NSString *second) {
            [self.hour setTitle:hour forState:0];
            [self.minute setTitle:minute forState:0];
            [self.second setTitle:second forState:0];
        }];
        if (_productsM.startDifference == 0) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }else{
    _productsM.difference --;
    [NSDate getdifferenceWithTime:_productsM.difference back:^(NSString *hour, NSString *minute, NSString *second) {
        [self.hour setTitle:hour forState:0];
        [self.minute setTitle:minute forState:0];
        [self.second setTitle:second forState:0];
    }];
    if (_productsM.difference == 0) {
        [self.timer invalidate];
        self.timer = nil;
    }
    }
}
@end

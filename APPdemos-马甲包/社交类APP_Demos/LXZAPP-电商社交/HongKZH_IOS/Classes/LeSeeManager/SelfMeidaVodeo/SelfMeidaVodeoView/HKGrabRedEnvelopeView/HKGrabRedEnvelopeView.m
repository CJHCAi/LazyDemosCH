//
//  HKGrabRedEnvelopeView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKGrabRedEnvelopeView.h"
#import "ZSUserHeadBtn.h"
#import "UIButton+ZSYYWebImage.h"
#import "GetMediaAdvAdvByIdRespone.h"
@interface HKGrabRedEnvelopeView()
@property (nonatomic,weak) IBOutlet UIButton *robBtn;
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *headBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userH;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *robTop;
@end

@implementation HKGrabRedEnvelopeView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKGrabRedEnvelopeView" owner:self options:nil].firstObject;
        UIImage*image = [UIImage imageNamed:@"userQuan"];
        self.userH.constant = image.size.height;
    }
    return self;
}
-(void)robClick{
    if ([self.delegate respondsToSelector:@selector(gotorobRed)]) {
        [self.delegate gotorobRed];
    }
}
-(void)awakeFromNib{
    [super awakeFromNib];
    UIImage*image = [UIImage imageNamed:@"qhb"];
    self.robTop.constant = image.size.height*0.5;
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(robClick)];
    self.iconView.userInteractionEnabled = YES;
    [self.iconView addGestureRecognizer:tap];
//    [self.robBtn addTarget:self action:@selector(robClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)setDataM:(GetMediaAdvAdvByIdRespone *)dataM{
    _dataM = dataM;
    self.nameLabel.text = dataM.data.uName;
    [self.headBtn hk_setBackgroundImageWithURL:dataM.data.headImg forState:0 placeholder:kPlaceholderHeadImage];
}
@end

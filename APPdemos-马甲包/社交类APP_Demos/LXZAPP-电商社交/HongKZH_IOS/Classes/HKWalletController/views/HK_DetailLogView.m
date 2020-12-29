//
//  HK_DetailLogView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_DetailLogView.h"

@interface HK_DetailLogView ()

@property (nonatomic, strong)UILabel *logTipsTypeLabel;
@property (nonatomic, strong)UILabel *logTypeLabel;
@property (nonatomic, strong)UILabel *logTipTimeLabel;
@property (nonatomic, strong)UILabel *logTimeLabel;
@property (nonatomic, strong)UILabel *logTipsOrderLabel;
@property (nonatomic, strong)UILabel *logOrderLabel;
@property (nonatomic, strong)UILabel * leaveLabel;
@property (nonatomic, strong)UIImageView *logImageView;
@property (nonatomic, strong)UILabel *leaveCountLabel;
@property (nonatomic, strong)UILabel * logTipsDescLabel;
@property (nonatomic, strong)UILabel *logDescLabel;

@end

@implementation HK_DetailLogView

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        [self layoutSubviews];
    }
    return  self;
    
}
-(void)layoutSubviews {
    //类型
    [self addSubview:self.logTipsTypeLabel];
    [self addSubview:self.logTypeLabel];
    //时间
    [self addSubview:self.logTipTimeLabel];
    [self addSubview:self.logTimeLabel];
//   //交易单号
    [self addSubview:self.logTipsOrderLabel];
    [self addSubview:self.logOrderLabel];
//    //余额
    [self addSubview:self.leaveLabel];
    [self addSubview:self.logImageView];
    [self addSubview:self.leaveCountLabel];
//    //备注
    [self addSubview:self.logTipsDescLabel];
    [self addSubview:self.logDescLabel];
    
}

#pragma mark 懒加载
-(UILabel *)logTipsTypeLabel {
    if (!_logTipsTypeLabel) {
        _logTipsTypeLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,15,60,10)];
        [AppUtils getConfigueLabel:_logTipsTypeLabel font:PingFangSCMedium13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"类型:"];
    }
    return _logTipsTypeLabel;
}
-(UILabel *)logTypeLabel {
    if (!_logTypeLabel) {
        _logTypeLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.logTipsTypeLabel.frame)+20,CGRectGetMinY(self.logTipsTypeLabel.frame),SCREEN_WIDTH_S-73-40,CGRectGetHeight(self.logTipsTypeLabel.frame))];
        [AppUtils getConfigueLabel:_logTypeLabel font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"充值"];
    }
    return _logTypeLabel;
    
}
-(UILabel *)logTipTimeLabel {
    if (!_logTipTimeLabel) {
        _logTipTimeLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.logTipsTypeLabel.frame),CGRectGetMaxY(self.logTipsTypeLabel.frame)+15,CGRectGetWidth(self.logTipsTypeLabel.frame),CGRectGetHeight(self.logTipsTypeLabel.frame))];
        [AppUtils getConfigueLabel:_logTipTimeLabel font:PingFangSCMedium13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"时间:"];
    }
    return _logTipTimeLabel;
}
-(UILabel *)logTimeLabel {
    if (!_logTimeLabel) {
        _logTimeLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.logTipsTypeLabel.frame)+20,CGRectGetMaxY(self.logTypeLabel.frame)+15,CGRectGetWidth(self.logTypeLabel.frame),CGRectGetHeight(self.logTypeLabel.frame))];
        [AppUtils getConfigueLabel:_logTimeLabel font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"2018.06.28 16:20"];
    }
    return _logTimeLabel;
    
}
-(UILabel *)logTipsOrderLabel {
    if (!_logTipsOrderLabel) {
        _logTipsOrderLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.logTipTimeLabel.frame),CGRectGetMaxY(self.logTipTimeLabel.frame)+15,CGRectGetWidth(self.logTipTimeLabel.frame),CGRectGetHeight(self.logTipTimeLabel.frame))];
        [AppUtils getConfigueLabel:_logTipsOrderLabel font:PingFangSCMedium13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"交易单号:"];
    }
    return _logTipsOrderLabel;
}

-(UILabel *)logOrderLabel {
    if (!_logOrderLabel) {
        _logOrderLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.logTipsTypeLabel.frame)+20,CGRectGetMaxY(self.logTimeLabel.frame)+9,CGRectGetWidth(self.logTimeLabel.frame),40)];
        [AppUtils getConfigueLabel:_logOrderLabel font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"314591212435454545344343244546546545453434365656454523"];
        _logOrderLabel.numberOfLines =0;
    }
    return _logOrderLabel;
    
}

//余额
-(UILabel *)leaveLabel {
    if (!_leaveLabel) {
        _leaveLabel =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.logTipsOrderLabel.frame),CGRectGetMaxY(self.logOrderLabel.frame)+12,CGRectGetWidth(self.logTipsOrderLabel.frame),CGRectGetHeight(self.logTipsOrderLabel.frame))];
         [AppUtils getConfigueLabel:_leaveLabel font:PingFangSCMedium13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"余额:"];
        
    }
    return _leaveLabel;
}

-(UILabel *)logTipsDescLabel {
    if (!_logTipsDescLabel) {
        _logTipsDescLabel =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.logTipsOrderLabel.frame),CGRectGetMaxY(self.leaveLabel.frame)+15,CGRectGetWidth(self.leaveLabel.frame),CGRectGetHeight(self.leaveLabel.frame))];
        [AppUtils getConfigueLabel:_logTipsDescLabel font:PingFangSCMedium13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"备注:"];
    }
    return _logTipsDescLabel;
}

-(UIImageView *)logImageView {
    if (!_logImageView) {
        _logImageView =[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.logTimeLabel.frame),CGRectGetMinY(self.leaveLabel.frame),13,13)];
        _logImageView.image =[UIImage imageNamed:@"514_goldc_"];
    }
    return _logImageView;
}
-(UILabel *)leaveCountLabel {
    if (!_leaveCountLabel) {
        _leaveCountLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.logImageView.frame)+2,CGRectGetMinY(self.logImageView.frame),200,CGRectGetHeight(self.leaveLabel.frame))];
          [AppUtils getConfigueLabel:_leaveCountLabel font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@""];
    }
    return _leaveCountLabel;
}
-(UILabel *)logDescLabel {
    if (!_logDescLabel) {
        _logDescLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.logImageView.frame),CGRectGetMinY(self.logTipsDescLabel.frame),CGRectGetWidth(self.logTimeLabel.frame),CGRectGetHeight(self.logTipsDescLabel.frame))];
        [AppUtils getConfigueLabel:_logDescLabel font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"快捷充值"];
     }
    return _logDescLabel;
}

-(void)upDateLogDatasWithModel:(LogDetailData *)data {
    if ([data.type isEqualToString:@"1"]) {
        self.logTypeLabel.text =@"充值";
        self.logDescLabel.text =@"快捷充值";
        
    }else {
        self.logTypeLabel.text =@"消费";
        self.logDescLabel.text =@"账户支出";
    }
    self.logTimeLabel.text =data.createDate;
    NSString * lastCurrencyStr = [NSString stringWithFormat:@"%zd",data.lastCurrency];
    NSMutableString *stringLast =[[NSMutableString alloc] initWithString:lastCurrencyStr];
    if (stringLast.length >2) {
        [stringLast insertString:@" " atIndex:2];
    }
    self.leaveCountLabel.text =stringLast;
    
}

@end

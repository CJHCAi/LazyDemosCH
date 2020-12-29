//
//  HKMyOrderStaueView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyOrderStaueView.h"
#import "UIView+Xib.h"
@interface HKMyOrderStaueView()
@property (weak, nonatomic) IBOutlet UIButton *one;
@property (weak, nonatomic) IBOutlet UIButton *submit;
@property (weak, nonatomic) IBOutlet UIButton *waitBtn;
@property (weak, nonatomic) IBOutlet UIButton *two;
@property (weak, nonatomic) IBOutlet UIButton *payBnt;
@property (weak, nonatomic) IBOutlet UIButton *threen;
@property (weak, nonatomic) IBOutlet UIButton *waitFH;
@property (weak, nonatomic) IBOutlet UIButton *four;
@property (weak, nonatomic) IBOutlet UIButton *FHIng;
@property (weak, nonatomic) IBOutlet UIButton *five;
@property (weak, nonatomic) IBOutlet UIButton *six;
@property (weak, nonatomic) IBOutlet UIButton *consignee;
@property (weak, nonatomic) IBOutlet UIImageView *waitFhImage;
@property (weak, nonatomic) IBOutlet UIImageView *waitPayImage;
@property (weak, nonatomic) IBOutlet UIImageView *fhIng;
@property (weak, nonatomic) IBOutlet UIButton *fhEd;

@property (nonatomic,assign) int frist;

@property (weak, nonatomic) IBOutlet UILabel *oneLabel;

@property (weak, nonatomic) IBOutlet UILabel *twoLabel;

@property (weak, nonatomic) IBOutlet UILabel *thressLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourLabel;

@end


@implementation HKMyOrderStaueView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupSelfNameXibOnSelf];
}
-(void)setStatue:(OrderFormStatue)statue{
    _statue = statue;
    switch (statue) {
        case OrderFormStatue_payed:{
            self.one.selected = YES;
            self.one.selected = YES;
            self.submit.selected = YES;
            self.waitBtn.selected = NO;
            self.two.selected = YES;
            self.payBnt.selected = YES;
            self.threen.selected = YES;
            self.waitFH.selected = YES;
            self.four.selected = NO;
            self.FHIng.selected = NO;
            self.five.selected = NO;
            self.fhEd.selected = NO;
            self.consignee.selected = NO;
            self.waitFhImage.hidden = NO;
            self.waitPayImage.hidden = YES;
            self.fhIng.hidden = YES;
            
        }
            break;
        case OrderFormStatue_waitPay:{
            self.one.selected = YES;
            self.submit.selected = YES;
            self.waitBtn.selected = YES;
            self.two.selected = NO;
            self.payBnt.selected = NO;
            self.threen.selected = NO;
            self.waitFH.selected = NO;
            self.four.selected = NO;
            self.FHIng.selected = NO;
            self.five.selected = NO;
            self.fhEd.selected = NO;
            self.consignee.selected = NO;
            self.waitFhImage.hidden = YES;
            self.waitPayImage.hidden = NO;
            self.fhIng.hidden = YES;
            
        }
            break;
        case OrderFormStatue_cnsignment:{
            self.one.selected = YES;
            self.one.selected = YES;
            self.submit.selected = YES;
            self.waitBtn.selected = NO;
            self.two.selected = YES;
            self.payBnt.selected = YES;
            self.threen.selected = YES;
            self.waitFH.selected = NO;
            self.four.selected = YES;
            self.FHIng.selected = YES;
            self.five.selected = YES;
            self.fhEd.selected = YES;
            self.consignee.selected = NO;
            self.waitFhImage.hidden = YES;
            self.waitPayImage.hidden = YES;
            self.fhIng.hidden = NO;
        }
            break;
        default:
            break;
    }
}
-(void)setAfterStaue:(AfterSaleViewStatue)afterStaue{
    _afterStaue = afterStaue;
    if ((self.statue >= 4 &&(afterStaue == AfterSaleViewStatue_ReturnFinish||afterStaue == AfterSaleViewStatue_finish) )) {
        self.fourLabel.text = @"退款成功";
    }else{
        self.fourLabel.text = @"确认收货";
    }
}
@end

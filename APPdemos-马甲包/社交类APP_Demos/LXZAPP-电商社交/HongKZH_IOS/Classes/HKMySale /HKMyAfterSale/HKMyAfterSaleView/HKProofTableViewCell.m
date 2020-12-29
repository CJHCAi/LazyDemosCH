//
//  HKProofTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/6.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKProofTableViewCell.h"
#import "HKLineBtn.h"
#import "HKAfterSaleRespone.h"
#import "HKBasePictureBrowserView.h"
@interface HKProofTableViewCell()
@property (weak, nonatomic) IBOutlet HKAfterNode *nodeView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *proofDesc;
@property (weak, nonatomic) IBOutlet UIImageView *proofImage;

@property (weak, nonatomic) IBOutlet HKBasePictureBrowserView *picVIew;
@property (weak, nonatomic) IBOutlet HKLineBtn *leftBtn;
@property (weak, nonatomic) IBOutlet HKLineBtn *rightBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftBtnRight;
@property (weak, nonatomic) IBOutlet UIView *downView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downH;

@end

@implementation HKProofTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftBtn.layer.cornerRadius =4;
    self.leftBtn.layer.masksToBounds =YES;
    self.rightBtn.layer.cornerRadius =4;
    self.rightBtn.layer.masksToBounds =YES;
    
}
-(void)setModel:(HKAfterSaleRespone *)model{
    [super setModel:model];
    if (self.staue == model.data.afterState.intValue) {
        self.nodeView.isSelect = YES;
        self.downH.constant = 48;
        self.downView.hidden = NO;

    }else{
        self.downH.constant = 0;
        self.downView.hidden = YES;
        self.nodeView.isSelect = NO;
    }
    if (self.staue == AfterSaleViewStatue_ProofOfBuyerseller) {
        self.titleLabel.text = @"商家已提供举证内容，待买家举证";
        self.timeLabel.text = model.data.sellerProofDate;
        self.proofDesc.text = model.data.sellerProofDesc;
        self.picVIew.questionArray = [NSMutableArray arrayWithArray:model.data.sellerImgs];
    }else if (model.data.afterState.intValue == AfterSaleViewStatue_ProofOfBuyer){
        self.titleLabel.text = @"买家已提供举证内容，待商家处理";
        self.timeLabel.text = model.data.sellerProofDate;
        self.proofDesc.text = model.data.sellerProofDesc;
        self.picVIew.questionArray = [NSMutableArray arrayWithArray:model.data.buyerImgs];
    }
}
- (IBAction)centerClick:(id)sender {
    
    [self baseRefusingArefund];
}
- (IBAction)rightClick:(id)sender {
      
       //举证
       [self baseProof];
      
}
-(void)changeBtnTitles {
    [self.leftBtn setTitle:@"取消退款" forState:UIControlStateNormal];
    [self.rightBtn setTitle:@"举证" forState:UIControlStateNormal];
}

@end

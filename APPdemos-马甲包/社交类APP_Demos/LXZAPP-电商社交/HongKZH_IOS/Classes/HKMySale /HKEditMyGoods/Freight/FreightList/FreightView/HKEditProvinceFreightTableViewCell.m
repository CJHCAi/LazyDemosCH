//
//  HKEditProvinceFreightTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKEditProvinceFreightTableViewCell.h"
#import "HKFrieightPriceView.h"
@interface HKEditProvinceFreightTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet HKFrieightPriceView *editFrieight;

@end

@implementation HKEditProvinceFreightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(void)setModel:(HKFreightListSublist *)model{
    _model = model;
    self.editFrieight.subListM = model;
    self.cityLabel.text = model.provinceName;
  
}
- (IBAction)deleteFreiht:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(delegateSublist:)]) {
        [self.delegate delegateSublist:self.model];
    }
}
- (IBAction)selectPro:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectProWithModel:)]) {
        [self.delegate selectProWithModel:self.model];
    }
}
@end

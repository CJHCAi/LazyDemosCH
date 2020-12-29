//
//  HKFreightListTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKFreightListTableViewCell.h"
@interface HKFreightListTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *leftIcon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftW;
@property (weak, nonatomic) IBOutlet UIImageView *rigthIcon;

@end

@implementation HKFreightListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setModel:(HKFreightListData *)model{
    _model = model;
    if (model.isSystem.integerValue<0) {
        self.name.text = @"包邮";
        self.descLabel.text = @"全国所有地区包邮";
        self.rigthIcon.hidden = YES;
    }else{
        self.rigthIcon.hidden = NO;
        self.name.text = model.name;
        if (model.isExcept.integerValue == 1) {
            self.descLabel.text = model.provinceName;
        }else{
            self.descLabel.text = [NSString stringWithFormat:@"默认运费：%ld件内%ld元，每增加%ld件，增加运费%ld元",model.piece,model.money,model.addPiece,model.addMoney];
        }
    }
    
}
-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    if (isSelect) {
        self.leftIcon.image = [UIImage imageNamed:@"xuanzhong"];
        self.leftW.constant = 5;
    }else{
        self.leftIcon.image = nil;
        self.leftW.constant = 0;
    }
}
- (IBAction)enitFreight:(id)sender {
    if ([self.delegate respondsToSelector:@selector(gotoEditWithModel:)]) {
        [self.delegate gotoEditWithModel:self.model];
    }
}
@end

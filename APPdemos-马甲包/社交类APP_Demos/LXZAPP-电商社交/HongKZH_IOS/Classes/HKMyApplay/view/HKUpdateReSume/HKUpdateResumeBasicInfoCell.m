//
//  HKUpdateResumeBasicInfoCell.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKUpdateResumeBasicInfoCell.h"

@interface HKUpdateResumeBasicInfoCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *sexTf;
@property (weak, nonatomic) IBOutlet UITextField *educationTf;
@property (weak, nonatomic) IBOutlet UITextField *workingLifeTf;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTf;
@property (weak, nonatomic) IBOutlet UITextField *locationTf;
@property (weak, nonatomic) IBOutlet UITextField *telTf;
@property (weak, nonatomic) IBOutlet UITextField *emailTf;

@end

@implementation HKUpdateResumeBasicInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.bgView.layer.shadowOpacity = 0.5;
    self.bgView.layer.shadowOffset = CGSizeMake(1, 1);
    self.bgView.layer.borderWidth = 1.f;
    self.bgView.layer.borderColor = UICOLOR_HEX(0xdddddd).CGColor;
}
- (IBAction)buttonClick:(UIButton *)sender {
    if (self.updateResumeBlock) {
        self.updateResumeBlock();
    }
}

- (void)setInfoData:(HK_UserRecruitData *)infoData {
    if (infoData) {
        _infoData = infoData;
        self.nameTf.text = infoData.name;
        self.sexTf.text = infoData.sexName;
        self.educationTf.text = infoData.educationName;
        self.workingLifeTf.text = infoData.workingLifeName;
        self.birthdayTf.text = infoData.birthday;
        self.locationTf.text = infoData.locatedName;
        self.telTf.text = infoData.mobile;
        self.emailTf.text = infoData.email;
    }
}


@end

//
//  HKReseaInfoCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKReseaInfoCell.h"
#import "ZSUserHeadBtn.h"
#import "RecruitInfoRespone.h"
#import "UIButton+ZSYYWebImage.h"
@interface HKReseaInfoCell()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UILabel *areaInfo;
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *companyHead;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *companyDesc;
@property (weak, nonatomic) IBOutlet UILabel *descInfo;
@property (weak, nonatomic) IBOutlet UILabel *salaryName;

@end

@implementation HKReseaInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setRespone:(RecruitInfoRespone *)respone{
    _respone = respone;
    self.name.text = respone.data.title;
    self.salaryName.text = respone.data.salaryName;
    self.desc.text = [NSString stringWithFormat:@"%@ | %@ %@",respone.data.educationName,respone.data.experienceName,respone.data.educationName];
    self.area.text = respone.data.cityAreaName;
    self.areaInfo.text = respone.data.address;
    [self.companyHead hk_setBackgroundImageWithURL:respone.data.headImg forState:0 placeholder:kPlaceholderHeadImage];
    self.companyName.text = respone.data.name;
    self.companyDesc.text = respone.data.industryName;
    self.descInfo.text = respone.data.introduce;
}
- (IBAction)gotoCompany:(id)sender {
    if ([self.delegate respondsToSelector:@selector(gotoCompanyInfo)]) {
        [self.delegate gotoCompanyInfo];
    }
}
@end

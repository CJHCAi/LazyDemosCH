//
//  EnterpriseRecruitInfoTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "EnterpriseRecruitInfoTableViewCell.h"
#import "EnterpriseRecruitListRespone.h"
#import "CompanyView.h"
@interface EnterpriseRecruitInfoTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet CompanyView *headView;

@end

@implementation EnterpriseRecruitInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setRespone:(EnterpriseRecruitListRespone *)respone{
    _respone = respone;
    self.desc.text = respone.data.introduce;
    [self.headView setName:respone.data.name desc:[NSString stringWithFormat:@"%@|%@|%@",respone.data.industryName,respone.data.scaleName,respone.data.stageName] headImage:respone.data.headImg];
}
@end

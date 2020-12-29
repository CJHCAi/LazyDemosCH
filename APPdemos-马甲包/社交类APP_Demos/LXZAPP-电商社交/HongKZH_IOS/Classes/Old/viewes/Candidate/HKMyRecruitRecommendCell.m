//
//  HKMyRecruitRecommendCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyRecruitRecommendCell.h"
@interface HKMyRecruitRecommendCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *corporateLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *refreshLabel;

@end

@implementation HKMyRecruitRecommendCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImgView.layer.cornerRadius = 24;
    self.headImgView.layer.masksToBounds = YES;
}
- (void)setList:(HKMyRecruitRecommendList *)list {
    if (list) {
        _list = list;
        [AppUtils seImageView:self.headImgView withUrlSting:list.portrait placeholderImage:nil];
        
        self.nameLabel.text = list.name;
        self.corporateLabel.text = list.corporateName;
        self.tipLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@",list.placeName,list.workingLifeName,list.educationName];
        self.jobLabel.text = [NSString stringWithFormat:@"职位: %@",list.functionsName];
        self.refreshLabel.text = list.time;
    }
}

- (void)setCandidateList:(HKMyCandidateList *)list {
    if (list) {
        _candidateList = list;
      [AppUtils seImageView:self.headImgView withUrlSting:list.portrait placeholderImage:nil];
        self.nameLabel.text = list.name;
        self.corporateLabel.text = list.corporateName;
        self.tipLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@",list.placeName,list.workingLifeName,list.educationName];
        self.jobLabel.text = [NSString stringWithFormat:@"职位: %@",list.functionsName];
        self.refreshLabel.text = list.time;
    }
}

@end

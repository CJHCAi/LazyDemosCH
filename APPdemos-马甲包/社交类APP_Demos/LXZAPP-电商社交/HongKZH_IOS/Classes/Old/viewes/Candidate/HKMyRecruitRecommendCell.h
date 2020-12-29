//
//  HKMyRecruitRecommendCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HK_searchResponse.h"
#import "HKMyRecruitRecommend.h"
#import "HKMyCandidate.h"
@interface HKMyRecruitRecommendCell : UITableViewCell
@property (nonatomic, strong) HKMyRecruitRecommendList *list;
@property (nonatomic, strong) HKMyCandidateList *candidateList;

@property (nonatomic, strong) HK_searchList * resumList;
@end

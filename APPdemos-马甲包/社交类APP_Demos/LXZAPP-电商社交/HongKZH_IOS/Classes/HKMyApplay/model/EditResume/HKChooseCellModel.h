//
//  HKChooseCellModel.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HK_BaseInfoResponse.h"
#import "HKUpdateResumeHeadImgCell.h"
#import "HKUpdateResumeBasicInfoCell.h"
#import "HKResumeAddAllCell.h"
#import "HKCareerIntentionsCell.h"
#import "HKUserEducationalCell.h"
#import "HKUserExperienceCell.h"
#import "HKUserContentCell.h"
#import "HKFormSubmitViewController.h"
#import "HK_UserEducationalData.h"
#import "HK_UserExperienceData.h"
@interface HKChooseCellModel : NSObject

//求职意向 cell
+ (UITableViewCell *) careerIntentionCellWith:(HK_UserRecruitData *)recruitUserInfo vc:(UIViewController *)vc uploadSuccessBlock:(UploadSuccessBlock) block;
//教育经历 cell
+ (UITableViewCell *)educationalCellWithItems:(NSArray<HK_UserEducationalData *> *) userEducationalItems tableView:(UITableView *) tableView vc:(UIViewController *)vc uploadSuccessBlock:(UploadSuccessBlock) block;

//工作经历 cell
+ (UITableViewCell *)experienceCellWithItems:(NSArray<HK_UserExperienceData *> *)userExperienceItems tableView:(UITableView *) tableView vc:(UIViewController *)vc uploadSuccessBlock:(UploadSuccessBlock) block;

//自我描述
+ (UITableViewCell *)userContentCellWith:(HK_UserRecruitData *)recruitUserInfo vc:(UIViewController *)vc uploadSuccessBlock:(UploadSuccessBlock) block;

#pragma mark cell高度

//求职意向 cell
+ (CGFloat) careerIntentionCellHeightWith:(HK_UserRecruitData *)recruitUserInfo;

//教育经历 cell
+ (CGFloat)educationalCellHeightWithItems:(NSArray<HK_UserEducationalData *> *) userEducationalItems tableView:(UITableView *) tableView;

//工作经历 cell
+ (CGFloat)experienceCellHeightWithItems:(NSArray<HK_UserExperienceData *> *)userExperienceItems tableView:(UITableView *) tableView;

//自我描述
+ (CGFloat) userContentCellHeightWith:(HK_UserRecruitData *)recruitUserInfo;

@end

//
//  HKChooseCellModel.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKChooseCellModel.h"
#import "HKCareerIntentionsViewController.h"
#import "HKUpdateUserEducationViewController.h"
#import "HKUpdateUserExperienceViewController.h"
#import "HKUserContentViewController.h"

@implementation HKChooseCellModel

//求职意向 cell
+ (UITableViewCell *) careerIntentionCellWith:(HK_UserRecruitData *)recruitUserInfo vc:(UIViewController *)vc uploadSuccessBlock:(UploadSuccessBlock) block{
    if (recruitUserInfo.functionsName) {    //如果填了,就显示
        return [HKCareerIntentionsCell careerIntentionsCellWithBlock:^{
            DLog(@"修改职业意向");
            HKCareerIntentionsViewController *pushVc = [[HKCareerIntentionsViewController alloc] init];
            pushVc.infoData = recruitUserInfo;
            pushVc.uploadSuccessBlock = block;
            [vc.navigationController pushViewController:pushVc animated:YES];
        } infoData:recruitUserInfo];
    } else {
        return [HKResumeAddAllCell resumeAddCellWithTitle:@"职业意向" addCellBlock:^{
            DLog(@"添加职业意向");
            HKCareerIntentionsViewController *pushVc = [[HKCareerIntentionsViewController alloc] init];
            [vc.navigationController pushViewController:pushVc animated:YES];
        }];
    }
}

//教育经历 cell
+ (UITableViewCell *)educationalCellWithItems:(NSArray<HK_UserEducationalData *> *) userEducationalItems tableView:(UITableView *) tableView vc:(UIViewController *)vc uploadSuccessBlock:(UploadSuccessBlock) block{
    DLog(@"-------%ld",userEducationalItems.count);
    if(userEducationalItems.count > 0) {
        HKUserEducationalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKUserEducationalCell class])];
        if (cell == nil) {
            cell = [[HKUserEducationalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HKUserEducationalCell class]) block:^(NSInteger index, id obj) {
                HK_UserEducationalData *data = (HK_UserEducationalData *)obj;
                HKUpdateUserEducationViewController *pushVc = [[HKUpdateUserEducationViewController alloc] init];
                pushVc.infoData = data;
                pushVc.uploadSuccessBlock = block;
                [vc.navigationController pushViewController:pushVc animated:YES];
            } addResumeBlock:^{ //继续添加
                HKUpdateUserEducationViewController *pushVc = [[HKUpdateUserEducationViewController alloc] init];
                pushVc.uploadSuccessBlock = block;
                [vc.navigationController pushViewController:pushVc animated:YES];
            }];
        }
        cell.items = userEducationalItems;
        return cell;
    } else {    //没有添加过
        return [HKResumeAddAllCell resumeAddCellWithTitle:@"教育经历" addCellBlock:^{
            DLog(@"添加教育经历");
            HKUpdateUserEducationViewController *pushVc = [[HKUpdateUserEducationViewController alloc] init];
            pushVc.uploadSuccessBlock = block;
            [vc.navigationController pushViewController:pushVc animated:YES];
        }];
    }
}

//工作经历 cell
+ (UITableViewCell *)experienceCellWithItems:(NSArray<HK_UserExperienceData *> *)userExperienceItems tableView:(UITableView *) tableView vc:(UIViewController *)vc uploadSuccessBlock:(UploadSuccessBlock) block{
    if(userExperienceItems.count > 0) {
        HKUserExperienceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKUserExperienceCell class])];
        if (cell == nil) {
            cell = [[HKUserExperienceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HKUserExperienceCell class]) block:^(NSInteger index, id obj) {
                DLog(@"点击了第%ld行",index);
                HK_UserExperienceData *data = (HK_UserExperienceData *)obj;
                HKUpdateUserExperienceViewController *pushVc = [[HKUpdateUserExperienceViewController alloc] init];
                pushVc.infoData = data;
                pushVc.uploadSuccessBlock = block;
                [vc.navigationController pushViewController:pushVc animated:YES];
            } addResumeBlock:^{
                DLog(@"添加工作经历");
                HKUpdateUserExperienceViewController *pushVc = [[HKUpdateUserExperienceViewController alloc] init];
                pushVc.uploadSuccessBlock = block;
                [vc.navigationController pushViewController:pushVc animated:YES];
            }];
        }
        cell.items = userExperienceItems;
        return cell;
    } else {
        return [HKResumeAddAllCell resumeAddCellWithTitle:@"工作经历" addCellBlock:^{
            DLog(@"添加工作经历");
            HKUpdateUserExperienceViewController *pushVc = [[HKUpdateUserExperienceViewController alloc] init];
            pushVc.uploadSuccessBlock = block;
            [vc.navigationController pushViewController:pushVc animated:YES];
        }];
    }
}

//自我描述
+ (UITableViewCell *) userContentCellWith:(HK_UserRecruitData *)recruitUserInfo vc:(UIViewController *)vc uploadSuccessBlock:(UploadSuccessBlock) block {
    if (recruitUserInfo.content && ![@"" isEqualToString:recruitUserInfo.content]) {    //如果填了,就显示
        return [HKUserContentCell cellWithUserContent:recruitUserInfo.content cellBlock:^{
            DLog(@"修改个人描述");
            HKUserContentViewController *pushVc = [[HKUserContentViewController alloc] init];
            pushVc.data = recruitUserInfo;
            pushVc.uploadSuccessBlock = block;
            [vc.navigationController pushViewController:pushVc animated:YES];
        }];
    } else {
        return [HKResumeAddAllCell resumeAddCellWithTitle:@"自我描述" addCellBlock:^{
            DLog(@"添加自我描述");
            HKUserContentViewController *pushVc = [[HKUserContentViewController alloc] init];
            pushVc.uploadSuccessBlock = block;
            [vc.navigationController pushViewController:pushVc animated:YES];
        }];
    }
}

#pragma mark Cell高度

//求职意向 cellHeight
+ (CGFloat) careerIntentionCellHeightWith:(HK_UserRecruitData *)recruitUserInfo {
    if (recruitUserInfo.functionsName) {    //如果填了,就显示
        return 172;
    } else {
        return 100;
    }
}

//教育经历 cellHeight
+ (CGFloat)educationalCellHeightWithItems:(NSArray<HK_UserEducationalData *> *) userEducationalItems tableView:(UITableView *) tableView{
    if(userEducationalItems.count > 0) {
        return UITableViewAutomaticDimension;
    } else {    //没有添加过
        return 100;
    }
}

//工作经历 cellHeight
+ (CGFloat)experienceCellHeightWithItems:(NSArray<HK_UserExperienceData *> *)userExperienceItems tableView:(UITableView *) tableView{
    if(userExperienceItems.count > 0) {
        return UITableViewAutomaticDimension;
    } else {
        return 100;
    }
}

//自我描述 cellHeight
+ (CGFloat) userContentCellHeightWith:(HK_UserRecruitData *)recruitUserInfo {
    if (recruitUserInfo.content && ![@"" isEqualToString:recruitUserInfo.content]) {    //如果填了,就显示
        return UITableViewAutomaticDimension;
    } else {
        return 100;
    }
}



@end

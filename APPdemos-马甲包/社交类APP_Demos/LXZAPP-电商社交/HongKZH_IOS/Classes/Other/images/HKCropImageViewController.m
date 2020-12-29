//
//  HKCropImageViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/6.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCropImageViewController.h"
#import "HKPublishCommonModuleViewController.h"
#import "HKEnterpriseRecruitViewController.h"
#import "HKReleaseResumeViewController.h"
#import "HKReleasePhotographyViewController.h"
#import "HKReleaseMarryViewController.h"
#import "HKReleaseMarryViewController.h"
#import "HKEditResumeViewController.h"
#import "HKUpdateReleaseRecruitViewController.h"
@interface HKCropImageViewController ()

@end

@implementation HKCropImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)okBtnAction{
    [super okBtnAction];
      HKReleaseVideoParam *releaseParm = [HKReleaseVideoParam shareInstance];
    switch (self.type) {
        case ENUM_PublishTypePublic:    //发布公共模块
        {
            HKPublishCommonModuleViewController *vc = [[HKPublishCommonModuleViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case ENUM_PublishTypeRecruit:   //发布企业招聘
        {
            //认证成功跳转到发布页面
            HKEnterpriseRecruitViewController *vc1 = [[HKEnterpriseRecruitViewController alloc] init];
            vc1.enterpriseId = releaseParm.userEnterpriseId;
            [self.navigationController pushViewController:vc1 animated:YES];
        }
            break;
        case ENUM_PublishTypeResume:    //发布个人简历
        {
            HKReleaseResumeViewController *vc = [[HKReleaseResumeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case ENUM_PublishTypePhotography:   //发布摄影
        {
            HKReleasePhotographyViewController *vc = [[HKReleasePhotographyViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case ENUM_PublishTypeMarry: //发布征婚交友
        {
            HKReleaseMarryViewController *vc = [[HKReleaseMarryViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case ENUM_PublishTypeEditResume: //编辑视频简历
        {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[HKEditResumeViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                    return;
                }
            }
        }
            break;
        case ENUM_PublishTypeEditRecruitment:   //编辑招聘
        {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[HKUpdateReleaseRecruitViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                    return;
                }
            }
        }
            
        default:
            break;
    }
}

@end

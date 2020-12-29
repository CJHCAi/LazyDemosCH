//
//  HKFrindInfoHeaderView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKMediaInfoResponse.h"
#import "HKMyFollowAndFans.h"
#import "HKCompanyResPonse.h"

@protocol headBtnClickDelegete <NSObject>

-(void)TopInfoClickWithSender:(NSInteger)index;

@end


@interface HKFrindInfoHeaderView : UIView
@property (nonatomic, strong)HKMediaInfoResponse *response;
@property (nonatomic, strong)HKMyFollowAndFansList *model;
@property (nonatomic, assign)BOOL isCompany;
@property (nonatomic, strong)HKCompanyResPonse *comRes;
@property (nonatomic, weak)id <headBtnClickDelegete>delegete;
@end

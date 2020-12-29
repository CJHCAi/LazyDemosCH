//
//  HKRecruitScreenView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/14.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKTitleAndImageBtn.h"
@protocol HKRecruitScreenViewDelegate <NSObject>

@optional
-(void)goToClick:(NSInteger)tag;

@end
@interface HKRecruitScreenView : UIView
@property (nonatomic,weak) id<HKRecruitScreenViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet HKTitleAndImageBtn *btn1;
@property (weak, nonatomic) IBOutlet HKTitleAndImageBtn *btn2;
@property (weak, nonatomic) IBOutlet HKTitleAndImageBtn *btn3;
@property (weak, nonatomic) IBOutlet HKTitleAndImageBtn *btn4;

@end

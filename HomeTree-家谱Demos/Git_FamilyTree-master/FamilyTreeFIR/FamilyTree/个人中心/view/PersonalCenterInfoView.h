//
//  PersonalCenterInfoView.h
//  FamilyTree
//
//  Created by 姚珉 on 16/6/4.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadImageView.h"
#import "MemallInfoModel.h"

@interface PersonalCenterInfoView : UIView
/** 头像视图*/
@property (nonatomic, strong) HeadImageView *headIV;

-(void)reloadData:(NSArray<MemallInfoHyjpModel *> *)hyjpArr;

@end

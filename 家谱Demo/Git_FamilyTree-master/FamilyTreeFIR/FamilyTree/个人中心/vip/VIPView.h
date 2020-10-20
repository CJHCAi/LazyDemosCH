//
//  VIPView.h
//  FamilyTree
//
//  Created by 姚珉 on 16/6/13.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIPInfoModel.h"
#import "VIPGrowUpModel.h"

@class VIPView;

@protocol VIPViewDelegate <NSObject>

-(void)clickVipBackBtn;

@end

@interface VIPView : UIView
/** 代理人*/
@property (nonatomic, weak) id<VIPViewDelegate> delegate;

-(void)reloadVIPInfoData:(NSArray<VIPInfoModel *> *)VIPInfoArr;
-(void)reloadVIPGrowUpData:(VIPGrowUpModel *)vipGrowUpModel;
@end

//
//  HKCircleSetting TableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetCellDelegete <NSObject>

-(void)updateCoverImage;
-(void)updateCicleName;
-(void)updateDescInfo;
-(void)updateNumCount;
-(void)updateJoinMethod;
-(void)updateCaterGrory;
-(void)pushMemberVc;
-(void)updateGoodsNumber;
//选择商品展示.
-(void)chooseProduct;

@end
@class HKMyCircleData;
@interface HKCircleSetting_TableViewCell : UITableViewCell
+(instancetype)circleSetting_TableViewCellWithTableView:(UITableView*)tableView;
@property (nonatomic, strong)HKMyCircleData *model;
@property (nonatomic, weak) id <SetCellDelegete> delegete;
@end

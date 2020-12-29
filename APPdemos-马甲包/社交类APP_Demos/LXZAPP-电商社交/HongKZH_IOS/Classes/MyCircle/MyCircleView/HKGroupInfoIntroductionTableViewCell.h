//
//  HKGroupInfoIntroductionTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKMyCircleData;
@protocol HKGroupInfoIntroductionTableViewCellDelagate <NSObject>

@optional
-(void)addGroup:(int)state;
-(void)checkCicleMember:(HKMyCircleData *)model;
-(void)pushShopDetail:(NSInteger)sender;
@end
@interface HKGroupInfoIntroductionTableViewCell : UITableViewCell
@property (nonatomic, strong)HKMyCircleData *model;
@property (nonatomic, strong)UISwitch *sw;
+(instancetype)groupInfoIntroductionTableViewCellWithTableView:(UITableView*)tableView;
@property (nonatomic,weak) id<HKGroupInfoIntroductionTableViewCellDelagate> delegate;
@end

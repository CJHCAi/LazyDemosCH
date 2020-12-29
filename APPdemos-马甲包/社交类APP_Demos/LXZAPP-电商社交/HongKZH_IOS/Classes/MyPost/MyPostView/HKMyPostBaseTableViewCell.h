//
//  HKMyPostBaseTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/7.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKMyPostsRespone.h"
#import "HKMyPostToolVIew.h"
@class HKMydyamicDataModel;
@protocol HKMyPostBaseTableViewCellDelegate <NSObject>

-(void)shareWithModel:(HKMyPostModel*)model;
-(void)commitWithModel:(HKMyPostModel*)model;
-(void)praiseWithModel:(HKMyPostModel*)model;

//新增的代理方法.
-(void)showUserDetailWithModel:(HKMyPostModel *)model;
-(void)showActionSheetWithModel:(HKMyPostModel *)model andIndexPath:(NSIndexPath *)path;

@end
@interface HKMyPostBaseTableViewCell : UITableViewCell<HKMyPostToolVIewDelegate>
+(instancetype)myPostBaseTableViewCellWithTableView:(UITableView*)tableView;
@property (nonatomic, strong)HKMyPostModel *model;
@property (nonatomic, strong)HKMydyamicDataModel*dataModel;
@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic,weak) id<HKMyPostBaseTableViewCellDelegate> delegate;

@property(nonatomic, assign) BOOL isHideTool;
@end

//
//  PrivateWorshipView.h
//  FamilyTree
//
//  Created by 姚珉 on 16/6/1.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorshipModel.h"

@class PrivateWorshipView;
@protocol PrivateWorshipViewDelegate <NSObject>

-(void)PrivateWorshipView:(PrivateWorshipView *)privateWorshipView didSelect:(BOOL)isEditing;

-(void)TableView:(UITableView *)tableView didSelectTableRowAtIndexPath:(NSIndexPath *)index;
-(void)PrivateWorshipViewDidSelectedCreateCem:(PrivateWorshipView *)privateWorshipView;
@end


@interface PrivateWorshipView : UIView
/** 我的私人墓园*/
@property (nonatomic, strong) UITableView *myTableView;
/** 墓园排行*/
@property (nonatomic, strong) UITableView *cemeterialListTableView;
/** 是否编辑状态*/
@property (nonatomic, assign) BOOL PrivateWorshipEdit;

/** 我的墓园数组*/
@property (nonatomic, strong) NSMutableArray<WorshipDatalistModel *> *PrivateViewMyWorshipArr;

/** 墓园排行数组*/
@property (nonatomic, strong) NSMutableArray<WorshipDatalistModel *> *PrivateViewAllWorshipArr;

/** 代理*/
@property (nonatomic, weak) id<PrivateWorshipViewDelegate> delegate;


@end

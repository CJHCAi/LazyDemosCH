//
//  PrivateWorshipTableViewCell.h
//  FamilyTree
//
//  Created by 姚珉 on 16/6/1.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorshipModel.h"

@class PrivateWorshipTableViewCell;
@protocol  PrivateWorshipTableViewCellDelegate<NSObject>

-(void)cemeterialDidEdit:(PrivateWorshipTableViewCell *)cell;
-(void)cemeterialDidDelete:(PrivateWorshipTableViewCell *)cell;

@end

@interface PrivateWorshipTableViewCell : UITableViewCell
/** 编辑按钮*/
@property (nonatomic, strong) UIButton *editBtn;
/** 删除按钮*/
@property (nonatomic, strong) UIButton *deleteBtn;
/** 代理人*/
@property (nonatomic, weak) id<PrivateWorshipTableViewCellDelegate> delegate;
/** 祭陵图*/
@property (nonatomic, strong) UIImageView *cemeterialImageView;

/** 墓园列表详情模型*/
@property (nonatomic, strong) WorshipDatalistModel *worshipDatalistModel;

/** 墓园ID标签*/
@property (nonatomic, strong) UILabel *cemeterialIDLB;

@end

//
//  HKToolCommtiTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "InfoMediaAdvCommentListRespone.h"
@protocol HKToolCommtiTableViewCellDelegate <NSObject>

@optional
-(void)commitWithAdvCommentModel:(InfoMediaAdvCommentListModels*)model;

@end
@interface HKToolCommtiTableViewCell : BaseTableViewCell
@property (nonatomic, strong)InfoMediaAdvCommentListModels *model;
@property(nonatomic, assign) int type;
@property (nonatomic,weak) id<HKToolCommtiTableViewCellDelegate> delegate;
@end

//
//  HKPostCommitCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKpostComentResponse.h"
#import "HKPostCommentInfoResponse.h"
#import "HKReCommentListResponse.h"
@protocol CommentCellBtnDelegete <NSObject>

@optional
-(void)ClickCellWithSender:(UIButton *)sender andIndex:(NSInteger)index withModel:(HKCommentList *)model;
-(void)pushUserDetailWithModel:(HKCommentList *)model;

//-(void)ClickInfoCellWithSender:(UIButton *)sender andIndex:(NSInteger)index;

@end
@interface HKPostCommitCell : UITableViewCell

@property (nonatomic, strong)HKCommentList *model;

@property (nonatomic, strong)HKCommentInfoData *dataModel;

@property (nonatomic, weak)id <CommentCellBtnDelegete>delegete;

@property (nonatomic, strong)HKReCommentList *list;

@end

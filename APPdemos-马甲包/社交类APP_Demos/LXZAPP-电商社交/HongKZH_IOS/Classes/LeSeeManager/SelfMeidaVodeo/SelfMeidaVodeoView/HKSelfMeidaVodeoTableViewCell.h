//
//  HKSelfMeidaVodeoTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "SelfMediaRespone.h"
#import "GetMediaAdvAdvByIdRespone.h"
@protocol HKSelfMeidaVodeoTableViewCellDelegate <NSObject>

@optional
-(void)showtoolViewWIthIndex:(NSInteger)index andIndexPath:(NSIndexPath*)indexPath;

@end
@interface HKSelfMeidaVodeoTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (nonatomic, strong)SelfMediaModelList *model;
@property (nonatomic,weak) NSIndexPath *indexpath;

-(void)addVideo:(NSString*)urlString;
@property(nonatomic, assign) HKPalyStaue staue;
@property (nonatomic, strong)GetMediaAdvAdvByIdRespone *dataM;
@property (nonatomic,weak) id<HKSelfMeidaVodeoTableViewCellDelegate> delegate;
@end

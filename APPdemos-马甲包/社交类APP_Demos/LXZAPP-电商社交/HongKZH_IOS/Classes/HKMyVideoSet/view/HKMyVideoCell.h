//
//  HKMyVideoCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/6.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKMyVideo.h"
#import "HKUserVideoResponse.h"
#import "HKHomeTool.h"
@interface HKMyVideoCell : UICollectionViewCell
@property(nonatomic , weak) UIView* bottomV;
@property (nonatomic, strong) HKMyVideoList *myList;
@property (nonatomic, strong)HKRecommendListData *data;
@property (nonatomic, strong)HKUserVideoList *userList;
//推荐页面
@property (nonatomic, assign)BOOL isRecond;
-(CGSize)calcSelfSize;

-(void)setUserVideoInfo:(NSString *)name andHeadImg:(NSString *)headImg;

@end

//
//  HKGroupMainerView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKPostDetailData;
typedef void (^groupMianerBlock)( NSInteger index);

@interface HKGroupMainerView : UIView

+ (void)showGroupItemWithselectSheetBlock:(groupMianerBlock)selectSheetBlock postModel:(HKPostDetailData*)model andController:(UIViewController *)controller;

@property (nonatomic, copy) groupMianerBlock  selectSheetBlock;

@property (nonatomic, strong)HKPostDetailData * model;

@end

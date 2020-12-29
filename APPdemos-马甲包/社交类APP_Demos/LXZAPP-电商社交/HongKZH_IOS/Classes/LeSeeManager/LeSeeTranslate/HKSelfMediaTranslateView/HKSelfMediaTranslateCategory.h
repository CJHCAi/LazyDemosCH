//
//  HKSelfMediaTranslateCategory.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKSelfMediaTranslateCategoryDelegate <NSObject>

@optional
-(void)itemClick:(NSInteger)item;

@end
@interface HKSelfMediaTranslateCategory : UIView
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic,weak) id<HKSelfMediaTranslateCategoryDelegate> delegate;

@property(nonatomic, assign) NSInteger selectIndex;
@end

//
//  HKHotAdvTypeItem.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnterpriseHotAdvTypeListRedpone.h"
@protocol HKHotAdvTypeItemDelegate <NSObject>

@optional
-(void)clickWithTag:(NSInteger)tag;
@end
@interface HKHotAdvTypeItem : UIView
@property (nonatomic, strong)EnterpriseHotAdvTypeListModel *model;
@property (nonatomic,weak) id<HKHotAdvTypeItemDelegate> delegate;
@property (nonatomic,assign) BOOL isSelect;
@end

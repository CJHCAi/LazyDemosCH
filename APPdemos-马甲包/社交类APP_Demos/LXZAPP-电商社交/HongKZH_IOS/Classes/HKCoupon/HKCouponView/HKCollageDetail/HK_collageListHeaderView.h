//
//  HK_collageListHeaderView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HK_CollageBtn.h"

@protocol rowBtnClickDelegete <NSObject>

-(void)changeRowBtnWithIndex:(NSInteger)index andSender:(HK_CollageBtn *)sender;

@end
@interface HK_collageListHeaderView : UIView

@property (nonatomic, weak)id <rowBtnClickDelegete>delegete;

@end

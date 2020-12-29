//
//  HKCicleHeadView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SenderClickDelegete <NSObject>

-(void)ClickSenderWithIndex:(NSInteger)index;
@end

@interface HKCicleHeadView : UIView

@property (nonatomic, weak)id <SenderClickDelegete>delegete;

@end

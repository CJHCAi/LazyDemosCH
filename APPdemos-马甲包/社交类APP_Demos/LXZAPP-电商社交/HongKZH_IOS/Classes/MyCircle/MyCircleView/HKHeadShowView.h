//
//  HKHeadShowView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BtnHeadClickDelegete <NSObject>

-(void)clickHead;
@end
@interface HKHeadShowView : UIView

@property (nonatomic, strong)NSMutableArray *imageArray;
@property (nonatomic, weak) id <BtnHeadClickDelegete>delegete;
@end

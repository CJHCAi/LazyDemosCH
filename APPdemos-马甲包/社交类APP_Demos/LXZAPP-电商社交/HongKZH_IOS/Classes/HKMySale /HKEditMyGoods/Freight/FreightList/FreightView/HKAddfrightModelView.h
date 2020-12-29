//
//  HKAddfrightModelView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKAddfrightModelViewDelegate <NSObject>
@optional
-(void)addModel;

@end
@interface HKAddfrightModelView : UIView
@property (nonatomic,weak) id<HKAddfrightModelViewDelegate> delegate;
@end

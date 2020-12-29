//
//  HKContactTheBuyerView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKContactTheBuyerViewDelegate <NSObject>

@optional
-(void)toCellContact;
@end
@interface HKContactTheBuyerView : UIView
@property (nonatomic,weak) id<HKContactTheBuyerViewDelegate> delegate;
@end

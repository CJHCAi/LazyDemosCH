//
//  HKMyDyamincHeadView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKMyDyamincHeadViewDelegate <NSObject>

@optional
-(void)gotoSearch;
-(void)swichParamsWithSender:(NSInteger)tag;

@end
@interface HKMyDyamincHeadView : UIView
@property (nonatomic,weak) id<HKMyDyamincHeadViewDelegate> delegate;
@end

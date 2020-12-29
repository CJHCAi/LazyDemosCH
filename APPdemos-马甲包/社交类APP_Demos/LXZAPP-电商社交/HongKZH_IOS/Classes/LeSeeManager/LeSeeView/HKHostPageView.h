//
//  HKHostPageView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKHostPageViewDelegate <NSObject>

@optional
-(void)clickHot:(NSInteger)tag;

@end
@interface HKHostPageView : UIView
@property (nonatomic, strong)NSMutableArray *array;
//@property(nonatomic, assign) CGFloat h;
@property (nonatomic,weak) id<HKHostPageViewDelegate> delegate;
@end

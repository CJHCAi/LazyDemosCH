//
//  HKEditImageView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKEditImageViewDelegate <NSObject>

@optional
-(void)imageUpdateWithIndex:(NSInteger)index;
@end
@interface HKEditImageView : UIView
@property (nonatomic, strong)NSMutableArray *imageArray;
@property (nonatomic,assign) int maxNum;
@property (nonatomic,weak) id<HKEditImageViewDelegate> delegate;

@property (nonatomic,assign) int type;
@end

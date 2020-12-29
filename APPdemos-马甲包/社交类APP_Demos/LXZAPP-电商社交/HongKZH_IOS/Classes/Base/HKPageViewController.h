//
//  HKPageViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"

@interface HKPageViewController : HKBaseViewController
+(instancetype)pageViewControllerWithVcArray:(NSArray*)vcArray;
@property (nonatomic, strong)UIPageViewController *pageVC;
@property (nonatomic, strong)NSMutableArray *array_VC;
-(void)btnClicks:(int)expressType;
-(void)setPageVcFrame;
@property (nonatomic,assign) int index;
-(void)setLeftANdRight;
//-(void)handleSwipeRightFrom:(UISwipeGestureRecognizer*)sender;
//-(void)handleSwipeFromLeft:(UISwipeGestureRecognizer*)sender;
@end

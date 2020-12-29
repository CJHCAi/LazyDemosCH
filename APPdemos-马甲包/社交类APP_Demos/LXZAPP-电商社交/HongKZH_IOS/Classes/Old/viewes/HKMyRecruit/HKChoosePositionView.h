//
//  HKChoosePositionView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKMyRecruit.h"
//typedef void(^HKChoosePositionViewBlock)(NSInteger index, NSString *title);
@protocol HKChoosePositionViewDeleagte <NSObject>
@optional
-(void)choosePositionViewBlock:(NSInteger)index title:(NSString*)title;

@end
@interface HKChoosePositionView : UIView
@property (nonatomic, strong) NSString *curTitle;
@property (nonatomic, strong) HKMyRecruitData *data;
//@property (nonatomic, copy) HKChoosePositionViewBlock block;
@property (nonatomic,weak) id<HKChoosePositionViewDeleagte> delegate;

+ (void)showInView:(UIView *)containerView
          curTitle:(NSString *)curTitle
              data:(HKMyRecruitData *)data;

@end

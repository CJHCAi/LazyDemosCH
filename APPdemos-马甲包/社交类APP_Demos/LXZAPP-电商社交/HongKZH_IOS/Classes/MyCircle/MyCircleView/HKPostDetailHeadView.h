//
//  HKPostDetailHeadView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKPostDetailResponse.h"

@protocol PostHeadViewDelegete <NSObject>

-(void)setClickBtnWithSender:(UIButton *)sender andTag:(NSInteger)tag;

-(void)enterCicleVc;

@end

@interface HKPostDetailHeadView : UIView

@property (nonatomic, strong)HKPostDetailResponse *response;

@property (nonatomic, weak) id <PostHeadViewDelegete>delegete;

-(void)setHeadDataWithResponse:(HKPostDetailResponse *)response;

@property (nonatomic, assign)CGFloat headH;

//@property (nonatomic, copy) NSString *headH;

@end

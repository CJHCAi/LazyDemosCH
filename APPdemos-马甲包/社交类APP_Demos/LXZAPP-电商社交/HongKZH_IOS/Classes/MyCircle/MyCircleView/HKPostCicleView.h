//
//  HKPostCicleView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKPostDetailResponse.h"
@protocol PreGoCiCleDelegete <NSObject>

-(void)pushCilce;

@end

@interface HKPostCicleView : UIView

@property (nonatomic, weak)id <PreGoCiCleDelegete>delegete;
@property (nonatomic, strong)HKPostDetailResponse *response;

@end

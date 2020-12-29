//
//  HKHelpVideoPlay.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WHAliyunSeniorVideoView.h"
@protocol HKHelpVideoPlayDelegate <NSObject>

@optional
-(void)playClick:(UIButton*)sender;
-(void)playFinish;
@end
@interface HKHelpVideoPlay : WHAliyunSeniorVideoView
@property (nonatomic,weak) id<HKHelpVideoPlayDelegate> delegate;
@property (nonatomic, copy)NSString *title;
@end

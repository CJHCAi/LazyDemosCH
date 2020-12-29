//
//  HKSelfMeidaVodeoNavView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GetMediaAdvAdvByIdRespone;
@protocol HKSelfMeidaVodeoNavViewDelagate <NSObject>

@optional
-(void)backVc;
//点击头像和更多按钮
-(void)headMoreSender:(NSInteger)tag withResponse:(GetMediaAdvAdvByIdRespone *)response;

@end
@interface HKSelfMeidaVodeoNavView : UIView
@property (nonatomic,weak) id<HKSelfMeidaVodeoNavViewDelagate> delegate;
@property (nonatomic, strong)GetMediaAdvAdvByIdRespone *respone;
@property(nonatomic, assign) NSInteger time;
@end

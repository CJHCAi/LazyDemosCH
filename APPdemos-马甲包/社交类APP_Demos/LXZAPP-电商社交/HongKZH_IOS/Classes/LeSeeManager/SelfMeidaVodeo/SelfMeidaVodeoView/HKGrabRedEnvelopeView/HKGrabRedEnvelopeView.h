//
//  HKGrabRedEnvelopeView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GetMediaAdvAdvByIdRespone;
@protocol HKGrabRedEnvelopeViewDelegate <NSObject>

-(void)gotorobRed;

@end
@interface HKGrabRedEnvelopeView : UIView
@property (nonatomic,weak) id<HKGrabRedEnvelopeViewDelegate> delegate;
@property (nonatomic, strong)GetMediaAdvAdvByIdRespone *dataM;
@end

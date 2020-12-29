//
//  HKHeadVodeoView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HKHeadVodeoViewDelegate <NSObject>

@optional
-(void)playFinish;
-(void)surplusTime:(NSInteger)surplusTime;
-(void)updatePlayHead:(HKPalyStaue)staue;
@end
typedef void(^BackBlcok)(void);

@interface HKHeadVodeoView : UIView
@property (nonatomic, copy)NSString *uslString;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (nonatomic,assign) HKPalyStaue staue;
@property (nonatomic, copy) BackBlcok block;
-(void)addVideoViewWithUrlString:(NSString*)urlString;
@property (nonatomic, copy)NSString *iconUrl;
@property (nonatomic,weak) id<HKHeadVodeoViewDelegate> delegate;
@end

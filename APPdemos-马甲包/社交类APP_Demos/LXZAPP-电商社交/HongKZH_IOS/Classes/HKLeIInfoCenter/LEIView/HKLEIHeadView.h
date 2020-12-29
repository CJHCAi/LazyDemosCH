//
//  HKLEIHeadView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKMyDataRespone;
@protocol HKLEIHeadViewDelegate <NSObject>

@optional

-(void)clickSetInfo;
- (void)saveClick ;
- (void)assistClick  ;
- (void)attention ;
- (void)vermicelliClick ;
- (void)setBtnClick;
-(void)editHeaderImage;
-(void)pushUserMainVc;
-(void)coinDetails;
@end
@interface HKLEIHeadView : UIView
@property (nonatomic,weak) id<HKLEIHeadViewDelegate> delegate;
@property (nonatomic, strong)HKMyDataRespone *respone;

-(void)setImageV:(UIImage *)picture;

-(void)cancelAllData;

@end

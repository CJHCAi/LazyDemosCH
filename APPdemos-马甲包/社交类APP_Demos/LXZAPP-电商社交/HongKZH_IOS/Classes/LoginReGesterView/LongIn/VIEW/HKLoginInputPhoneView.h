//
//  HKLoginInputPhoneView.h
//  HongKZH_IOS
//
//  Created by 王辉 on 2018/8/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKLoginInputPhoneViewDelegate <NSObject>
-(void)phoneAndPassword:(NSDictionary*)dict;
-(void)shortMessage:(NSString*)phone;
-(void)gotoForgetCode;
@end
@interface HKLoginInputPhoneView : UIView

@property (nonatomic,weak) id<HKLoginInputPhoneViewDelegate> delegate;

@end

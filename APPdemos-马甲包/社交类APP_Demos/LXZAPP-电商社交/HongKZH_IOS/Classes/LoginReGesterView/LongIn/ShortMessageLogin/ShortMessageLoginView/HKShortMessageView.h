//
//  HKShortMessageView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/22.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKShortMessageViewDelegate <NSObject>
@optional
-(void)nextToVc;
-(void)showLoginViews;

@end
@interface HKShortMessageView : UIView

@property (weak, nonatomic) IBOutlet UITextField *inputTextF;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UIButton *countryBtn;

@property (weak, nonatomic) IBOutlet UIButton *otherTypeLogin;

@property (nonatomic,weak) id<HKShortMessageViewDelegate> delegate;
@end

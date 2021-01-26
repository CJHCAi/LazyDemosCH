//
//  KLSignInView.h
//  KLCalendar
//
//  Created by kai lee on 16/7/26.
//  Copyright © 2016年 kai lee. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^signInBlock)();

@class KLSignInModel;
@interface KLSignInView : UIView

@property (nonatomic, strong) KLSignInModel *signModel;
/* 签到按钮 */
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;

@property (nonatomic, copy) signInBlock signInBlock;
@end

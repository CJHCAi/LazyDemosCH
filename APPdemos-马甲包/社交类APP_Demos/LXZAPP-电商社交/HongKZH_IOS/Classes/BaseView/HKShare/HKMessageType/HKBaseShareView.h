//
//  HKBaseShareView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareMessage.h"
@protocol HKBaseShareViewDelegate <NSObject>

@optional
-(void)contentClick;

@end
@interface HKBaseShareView : UIView
@property (nonatomic, strong)UIButton *iconBtn;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *descLabel;
@property (nonatomic, strong)ShareMessage *message;
@property (nonatomic,weak) id<HKBaseShareViewDelegate> delegate;
@end

//
//  HKDeleverView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

/**取消订单*/
typedef void(^senderClickBlock)(NSInteger sender,UIButton * btn);

@interface HKDeleverView : UIView

@property (nonatomic, copy) senderClickBlock sendBlock;

@end

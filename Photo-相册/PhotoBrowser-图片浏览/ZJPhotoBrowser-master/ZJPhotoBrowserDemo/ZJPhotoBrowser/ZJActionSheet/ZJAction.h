//
//  ZJAction.h
//  ZJPhotoBrowserDemo
//
//  Created by 陈志健 on 2017/4/14.
//  Copyright © 2017年 chenzhijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kZJActionScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kZJActionScreenHeight [UIScreen mainScreen].bounds.size.height

#define kZJActionHeight 50

@class ZJAction;
@protocol ZJActionDelegate <NSObject>

- (void)didSelectedZJAction:(ZJAction *)action;

@end

@interface ZJAction : UIView

- (instancetype)initWithTitle:(NSString *)title action:(void(^)())action;

@property (nonatomic, copy) void(^action)();

@property (nonatomic, weak) id<ZJActionDelegate>delegate;

@end

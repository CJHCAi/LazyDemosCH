//
//  XMNSizeView.h
//  XMNSizeTextExample
//
//  Created by shscce on 15/11/26.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UILabel+AdjustFont.h"

#define kXMNInset                   8
#define kXMNBorderInset             8
#define kXMNRotateScaleControlWidth 24


typedef NS_ENUM(NSUInteger, XMNRotateScaleViewState) {
    XMNRotateScaleViewStateNormal,
    XMNRotateScaleViewStateEditing,
};

@protocol XMNRotateScaleViewDelegate;
@interface XMNRotateScaleView : UIView

@property (nonatomic, weak) UIView *contentView; /**< 显示的具体内容view */
@property (nonatomic, weak) id<XMNRotateScaleViewDelegate> delegate;

@property (nonatomic, assign) CGSize minSize; /**< 最小的宽度 默认为CGSizeMake(76, 76)  */

@property (nonatomic, strong) UIColor *borderColor; /**< 边框颜色,默认红色 */
@property (nonatomic, assign) CGFloat borderWidth; /**< 边框粗细,默认为1.0f */

@property (nonatomic, assign) XMNRotateScaleViewState state;

@end


@protocol XMNRotateScaleViewDelegate <NSObject>

@optional
- (void)rotateScaleViewDidRotateAndScale:(XMNRotateScaleView *)rotateScaleView;

@end
//
//  LCSuspendCustomView.h
//  LuochuanAD
//
//  Created by care on 17/5/8.
//  Copyright © 2017年 luochuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WINDOWS [UIScreen mainScreen].bounds.size

@protocol SuspendCustomViewDelegate <NSObject>
@optional
- (void)suspendCustomViewClicked:(id)sender;
- (void)dragToTheLeft;
- (void)dragToTheRight;
- (void)dragToTheTop;
- (void)dragToTheBottom;


@end
@interface SuspendView : UIView
@end
@interface SuspendImageView : UIImageView
@end
@interface SuspendButton : UIButton
@end
@interface SuspendScrollView : UIScrollView
@end
@interface LCSuspendCustomView : UIView
@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, weak) id<SuspendCustomViewDelegate> suspendDelegate;
@property (nonatomic, strong) UIButton *customButton;
@property (nonatomic, strong) UIImageView *customImgV;
@property (nonatomic, strong) UIWebView *customGif;
@property (nonatomic, strong) SuspendScrollView *customScrollView;
@property (nonatomic, strong) SuspendView *customContentView;
- (void)initWithSuspendType:(NSString *)suspendType;
@end

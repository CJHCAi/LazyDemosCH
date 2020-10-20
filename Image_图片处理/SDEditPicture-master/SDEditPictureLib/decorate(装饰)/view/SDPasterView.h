//
//  SDPasterView.h
//  NestHouse
//
//  Created by shansander on 2017/5/6.
//  Copyright © 2017年 黄建国. All rights reserved.
//

#import <UIKit/UIKit.h>
extern CGFloat const defaultPasterViewW_H;

/**默认删除和缩放按钮的大小*/
#define btnW_H MAXSize(64)
/**默认的图片宽高*/
#define defaultImageViewW_H self.frame.size.width - btnW_H
/**缩放和删除按钮与图片的间隔距离*/
#define paster_insert_space btnW_H/2
/**总高度*/
#define PASTER_SLIDE 120
/**安全边框*/
#define SECURITY_LENGTH PASTER_SLIDE/2

@protocol SDPasterViewDelegate <NSObject>
@required;
@optional;
- (void)deleteThePaster:(UIView *)target;

- (void)SimplpTapForTagContentWithIndex:(NSInteger)index inView:(UIView *)target;
@end


@interface SDPasterView : UIView

@property (nonatomic,weak) id<SDPasterViewDelegate> delegate;

/**图片，所要加成贴纸的图片*/
@property (nonatomic, strong) UIImage *pasterImage;

@property (nonatomic, strong) UIPanGestureRecognizer *panResizeGesture;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, strong) UIPinchGestureRecognizer * pinchGesture;

@property (nonatomic, strong) UIRotationGestureRecognizer * rotationGesture;

@property (nonatomic, assign) NSInteger index;
/**隐藏“删除”和“缩放”按钮*/
- (void)hiddenBtn;
/**显示“删除”和“缩放”按钮*/
- (void)showBtn;

-(void)changePasterContentFrameView;
@end

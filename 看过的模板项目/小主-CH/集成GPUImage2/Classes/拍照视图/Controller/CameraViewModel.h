//
//  CameraViewModel.h
//  EmptyDemo
//
//  Created by apple on 2017/7/28.
//  Copyright © 2017年 LIZHAO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol CameraViewModelDelegate <NSObject>
//拍照
-(void)didShutterBtnClick;
//切换前后镜按钮
-(void)didToggleBtnClick;
//闪光灯
-(void)didFlashBtnClickWith:(UIButton*)btn;
//取消按钮
-(void)didCancleBtnClick;
@end
@interface CameraViewModel : NSObject

@property(nonatomic,weak)UIViewController * actionViewController;
// 拍照按钮
@property (nonatomic, strong)UIButton *shutterButton;
// 闪光灯按钮
@property(nonatomic,strong)UIButton * flashButton;
// 切换前后镜头的按钮
@property (nonatomic, strong)UIButton *toggleButton;

//返回按钮，（取消按钮）
@property(nonatomic,strong)UIButton * cancleButton;

@property (nonatomic,weak)id<CameraViewModelDelegate>delegate;

+(CameraViewModel*)shareManagerUI;
-(void)initUI;
-(void)AlertView:(NSString*)text;

- (void)shakeAnimationForView:(UIView *) view;

- (void)setViewDelegate:(UIViewController *)delegate;
@end

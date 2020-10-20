//
//  SDDiyBaseFunctionViewController.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/24.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+GetFromShowImage.h"

@interface SDDiyBaseFunctionViewController : UIViewController

@property (nonatomic, strong) UIImage * originImage;

@property (nonatomic, strong) UIImage * showImageView;

@property (nonatomic, copy)SDDiyImageFinishBlock diyFinishBlock;

/**
 init
 
 @param finishBlock 确定 渲染的block
 @return self
 */
- (instancetype)initWithFinishBlock:(SDDiyImageFinishBlock)finishBlock;


/**
 点击取消按钮，通知viewController dismissViewController
 */
- (void)onCancelAction;

/**
 点击确定按钮，通知viewController sure
 */
- (void)onSureAction;

@end

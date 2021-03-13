//
//  BJTSignView.h
//  BJTResearch
//
//  Created by yunlong on 2017/6/28.
//  Copyright © 2017年 yunlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BJTSignView : UIView
/**
 * 获取签名图片
 */
- (UIImage *)getSignatureImage;
/**
 * 清除签名
 */
- (void)clearSignature;

@end

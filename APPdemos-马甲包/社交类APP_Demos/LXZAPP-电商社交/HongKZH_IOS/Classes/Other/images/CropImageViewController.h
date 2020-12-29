//
//  CropImageViewController.h
//  WHCropImage
//
//  Created by 魏辉 on 16/9/5.
//  Copyright © 2016年 Weihui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CropImageViewController : UIViewController
- (instancetype)initWithCropImage:(UIImage *)cropImage;
- (void)okBtnAction;
@end

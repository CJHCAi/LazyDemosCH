//
//  CropperViewController.h
//  ImageCropper
//
//  Created by Zhuochenming on 16/1/8.
//  Copyright © 2016年 Zhuochenming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CropperViewController : UIViewController

@property (nonatomic, strong) UIImage *image;

- (void)done:(void(^)(NSArray *imageArray))done;

@end

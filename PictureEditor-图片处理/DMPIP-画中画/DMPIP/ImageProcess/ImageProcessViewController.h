//
//  ImageProcessViewController.h
//  LuoChang
//
//  Created by Rick on 15/5/20.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BigPreviewImageView;

@interface ImageProcessViewController : UIViewController


@property (strong, nonatomic) IBOutlet BigPreviewImageView *bigPreviewImageView;


@property(nonatomic,copy) UIImage *originalImage;

@property(nonatomic,strong) UIImage *afterFilterImage;


@end

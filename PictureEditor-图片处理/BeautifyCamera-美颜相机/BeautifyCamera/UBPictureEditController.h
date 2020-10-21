//
//  UBPictureEditController.h
//  BeautifyCamera
//
//  Created by sky on 2017/1/22.
//  Copyright © 2017年 guikz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UBPictureEditController : UIViewController

@property (nonatomic) UIImage * presentImage;


@property (nonatomic, copy) void(^ saveImage) (UIImage *);

@property (nonatomic, copy) void(^ willDismiss)();
@end

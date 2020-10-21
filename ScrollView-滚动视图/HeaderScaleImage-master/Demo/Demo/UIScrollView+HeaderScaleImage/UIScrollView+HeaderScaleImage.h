//
//  UIScrollView+HeaderScaleImage.h
//  GNHeaderScaleImageDemo
//
//  Created by gn on 16/7/29.
//  Copyright © 2016年 gn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (HeaderScaleImage)
@property (nonatomic, strong) UIImage *gn_headerScaleImage;
@property (nonatomic, assign) CGFloat gn_headerScaleImageHeight;
@end




@interface GNImageView : UIImageView
@property (nonatomic,assign) CGFloat gn_originalHeight;
@end
